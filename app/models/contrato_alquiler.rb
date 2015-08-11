# == Schema Information
#
# Table name: contrato_alquilers
#
#  id                     :integer          not null, primary key
#  nro_contrato           :string(255)
#  fecha_inicio           :date
#  fecha_fin              :date
#  archivo_contrato       :string(255)
#  canon_fijo_ml          :decimal(30, 2)   default(0.0)
#  canon_fijo_usd         :decimal(30, 2)   default(0.0)
#  porc_canon_ventas      :decimal(30, 2)   default(0.0)
#  monto_minimo_ventas    :decimal(30, 2)   default(0.0)
#  estado_contrato        :boolean
#  tienda_id              :integer
#  created_at             :datetime
#  updated_at             :datetime
#  requerida_venta        :boolean
#  tipo_canon_alquiler_id :integer
#



class ContratoAlquiler < ActiveRecord::Base
  before_create :set_missing_attributes_create
  before_update :clean_canon_alquiler
  belongs_to :tienda
  has_many :ventas, through: :tienda
  has_one :mall, through: :tienda
  belongs_to :tipo_canon_alquiler

  validates :archivo_contrato, presence: true
  validates :tipo_canon_alquiler_id, presence: true

  mount_uploader :archivo_contrato, FileUploader

  def clean_canon_alquiler
    tipo_canon_id = self.tipo_canon_alquiler.id
    if tipo_canon_id == 1 # "Fijo"
      self.canon_fijo_usd = self.canon_fijo_ml / CambioMoneda.last.cambio_ml_x_usd
      self.porc_canon_ventas = 0
      self.monto_minimo_ventas = 0
    elsif tipo_canon_id == 2 || tipo_canon_id == 3 # Variable VB y VN
      self.canon_fijo_ml = 0
      self.canon_fijo_usd = 0
      self.monto_minimo_ventas = 0
      self.requerida_venta = true
    elsif tipo_canon_id == 4 ||  tipo_canon_id == 5 # Fijo&Variable VB y VN
      self.canon_fijo_usd = self.canon_fijo_ml / CambioMoneda.last.cambio_ml_x_usd
      self.monto_minimo_ventas = self.canon_fijo_ml / (self.porc_canon_ventas / 100)
      self.requerida_venta = true
    else
      self.canon_fijo_ml = 0
      self.canon_fijo_usd = 0
      self.porc_canon_ventas = 0
      self.monto_minimo_ventas = 0
      self.requerida_venta = false
    end
  end

  def set_missing_attributes_create
    self.nro_contrato = NumerosControl.get_nro_contrato
    self.canon_fijo_usd = self.canon_fijo_ml / CambioMoneda.last.cambio_ml_x_usd if self.canon_fijo_ml.present? && self.canon_fijo_ml != 0
    self.monto_minimo_ventas = self.canon_fijo_ml / (self.porc_canon_ventas / 100) if self.porc_canon_ventas.present? && porc_canon_ventas != 0 && self.canon_fijo_ml.present? && self.canon_fijo_ml != 0
    self.requerida_venta = true if self.porc_canon_ventas.present? && self.porc_canon_ventas != 0
  end

  def fecha_inicio_fix
    self.fecha_inicio.strftime("%d/%m/%Y")
  end

  def fecha_fin_fix
    self.fecha_fin.strftime("%d/%m/%Y")
  end

  def archivo_contrato_pdf? #cambios de Lery para hacer que funcione si no tiene archivo cargado.
    if self.archivo_contrato.url.nil?
      return false
    else
      return true if self.archivo_contrato.url.split('.').last == 'pdf'
      return false
    end
  end
  #enum tipo_canon_alquiler: [:fijo, :variableVB, :variableVN, :fijo_y_variable_venta_bruta, :fijo_y_variable_venta_neta, :exonerado]

  def self.calculate_canonBorrar(contrato,monto_bruto,monto_neto)
    tipo_canon = contrato.tipo_canon_alquiler.id
    vmt = monto_bruto if tipo_canon == 2 || tipo_canon == 4
    vmt = monto_neto  if tipo_canon == 3 || tipo_canon == 5

    if tipo_canon == 1
      canon_fijo = contrato.canon_fijo_ml
      canon_variable = 0
    elsif tipo_canon == 2 || tipo_canon == 3
      canon_fijo = 0
      monto_minimo_v = contrato.monto_minimo_ventas
      if vmt >= monto_minimo_v
        canon_variable = (vmt - monto_minimo_v)*(contrato.porc_canon_ventas/100)
      else
        canon_variable = 0
      end
    elsif tipo_canon == 4 ||  tipo_canon == 5
      canon_fijo = contrato.canon_fijo_ml
      monto_minimo_v = contrato.monto_minimo_ventas

      if(vmt.to_f >= monto_minimo_v.to_f)
        canon_variable = (vmt - monto_minimo_v)*(contrato.porc_canon_ventas/100)
      else
        canon_variable = 0
      end
    else
      canon_fijo = 0
      canon_variable = 0
    end
    canon_fijo = 0 if canon_fijo.nil?
    canon_variable = 0 if canon_variable.nil?
    canon_alquiler = canon_fijo + canon_variable
    return  {canon_fijo: canon_fijo,canon_variable: canon_variable,canon_alquiler: canon_alquiler}
  end

  def calcular_canon_variable_ml(venta_monto_bruto,venta_monto_neto)
    canon_variable_ml = 0
    tipo_canon = self.tipo_canon_alquiler.id
    if tipo_canon >= 2 && tipo_canon <= 5
      if tipo_canon == 3 || tipo_canon == 5
        monto_ventas = venta_monto_neto
      else
        monto_ventas = venta_monto_bruto
      end
      monto_minimo_ventas = self.monto_minimo_ventas
      if monto_ventas >= monto_minimo_ventas
        canon_variable_ml = (monto_ventas - monto_minimo_ventas)*(self.porc_canon_ventas/100)
      end
    end
    return  canon_variable_ml
  end

  # Obtiene el contrato de alquiler mas reciente de la tienda
  def self.get_contrato_alquiler(tienda_id)
    where(tienda_id: tienda_id).last
  end

  # Obtiene el contrato de alquiler vigente de la tienda
  def self.get_contrato_vigente(tienda)
    self.where(estado_contrato: true, tienda_id: tienda.id)
  end

  # Obtiene el contrato de alquiler vigente a la fecha (mes-año), de la tienda
  def self.get_contrato_vigente_fecha(tienda_id,year,month)
    fecha = year.to_s + '/' + month.to_s + '/1'
    where("tienda_id = ? AND fecha_inicio <= ? AND fecha_fin >= ?",tienda_id,fecha,fecha).first
  end

  def self.get_tipo_canon_alquiler(tienda_id)
    where(tienda_id: tienda_id).last.tipo_canon_alquiler.tipo
  end

  def self.get_tipo_canon(tienda)
    where(tienda_id: tienda.id).last.tipo_canon_alquiler.tipo
  end


end
