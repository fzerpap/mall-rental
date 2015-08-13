# == Schema Information
#
# Table name: tiendas
#
#  id                        :integer          not null, primary key
#  nombre                    :string(255)
#  fecha_apertura            :date
#  fecha_cierre              :date
#  abierta                   :boolean
#  fecha_fin_contrato_actual :date
#  local_id                  :integer
#  actividad_economica_id    :integer
#  arrendatario_id           :integer
#  created_at                :datetime
#  updated_at                :datetime
#  monto_garantia            :decimal(30, 2)
#  monto_garantia_usd        :decimal(30, 2)
#  codigo_contable           :string(255)
#



class Tienda < ActiveRecord::Base
  belongs_to :local
  has_one :nivel_mall, through: :local
  has_one :tipo_local, through: :local
  belongs_to :actividad_economica
  belongs_to :arrendatario
  has_one :mall, through: :local
  has_many :contrato_alquilers

  accepts_nested_attributes_for :contrato_alquilers, allow_destroy: true, reject_if: :all_blank

  has_many :venta_mensuals
  has_many :venta_diariums, through: :venta_mensuals
  has_many :user_tiendas
  has_many :users, through: :user_tiendas
  has_many :cobranza_alquilers

  after_create :set_missing_attributes
  before_update :set_missing_attributes_update
  before_destroy :confirm_presence_of_contratos

  validates :local_id, :actividad_economica_id, :arrendatario_id, presence: true

  def confirm_presence_of_contratos
    if contrato_alquilers.any?
      return false
    end
  end

  def set_missing_attributes
    self.update(fecha_apertura: (self.contrato_alquilers.first.fecha_inicio rescue Date.today),
                abierta: true, fecha_fin_contrato_actual: (self.contrato_alquilers.last.fecha_fin rescue Date.today), monto_garantia_usd: (self.monto_garantia / CambioMoneda.last.cambio_ml_x_usd rescue nil))
  end

  def set_missing_attributes_update
    self.monto_garantia_usd = self.monto_garantia / CambioMoneda.last.cambio_ml_x_usd if self.monto_garantia.present?
  end

  def vencido?
    if self.contrato_alquilers.last.fecha_fin < Date.today
      return 'Si'
    else
      return 'No'
    end
  end


  def self.by_nivel_mall(nivel_mall_id)
    return where(nil) unless nivel_mall_id.present?
    where(nivel_malls: {id: nivel_mall_id})
  end

  def self.by_actividad_economica(actividad_economica_id)
    return where(nil) unless actividad_economica_id.present?
    where(actividad_economicas: {id: actividad_economica_id})
  end

  def self.by_vencimiento(vencido)
    return where(nil) unless vencido.present?
    if vencido == 'vencidos'
      return where("contrato_alquilers.fecha_fin < ?", Date.today)
    elsif vencido == 'vigentes'
      return where("contrato_alquilers.fecha_fin >= ?", Date.today)
    else
      where(nil)
    end
  end

  def self.by_rango_contrato(fecha_init, fecha_end)

    return where(nil) unless fecha_init.present? || fecha_end.present?
    where("contrato_alquilers.fecha_fin >= ? AND contrato_alquilers.fecha_inicio <= ?", fecha_end, fecha_init)
  end

  def self.by_tipo_local(tipo_local_id)
    return where(nil) unless tipo_local_id.present?
    where(tipo_locals: {id: tipo_local_id})
  end

  def self.valid_tiendas(user)
    return Tienda.joins(:local).joins(:mall).where(malls: {id: user.mall_id})
  end

  def self.by_cobranza_alquilers(fecha_init, fecha_end)
    return where(nil) unless fecha_init.present? || fecha_end.present?
    where("cobranza_alquilers.fecha_recibo_cobro >= ? OR cobranza_alquilers.fecha_recibo_cobro <= ?", fecha_end, fecha_init)
  end

  def self.get_ids_tiendas_mall(mall)
    mall.tiendas.pluck(:id)

  end


  def self.get_ventas_xtiendaBORRAR(mall,anio,mes)
    ventas = Array.new
    suma_ventas_tiendas = 0
    suma_ventas_bruto_tiendas = 0
    suma_total_canon = 0
    suma_canon_variable = 0
    suma_canon_fijo = 0
    suma_venta_neta = 0
    suma_total_ventas = 0
    mall.tiendas.each do |tienda|
      tipo_canon = ContratoAlquiler.get_tipo_canon(tienda)
      venta_mensual = VentaMensual.get_venta_mes_tienda(tienda,anio,mes)
      venta_mes = VentaMensual.suma_venta_mes(tienda,anio,mes)
      venta_neta_mes = VentaMensual.monto_neto_mes(tienda,anio,mes)
      ventas_bruto_mes = VentaMensual.monto_bruto_mes(tienda,anio,mes)
      suma_ventas_tiendas += venta_mes
      suma_ventas_bruto_tiendas += ventas_bruto_mes
      canon_fijo = CobranzaAlquiler.get_canon_fijo(tienda,anio,mes)
      canon_variable = CobranzaAlquiler.get_canon_variable(tienda,anio,mes)
      tiene_cobranza_alquiler = CobranzaAlquiler.tiene_cobranza(tienda,anio,mes)
      editable = VentaMensual.get_is_editable(tienda,anio,mes)
      total_canon = canon_fijo + canon_variable
      if tipo_canon == 3 || tipo_canon == 5
        total_monto_ventas = venta_neta_mes
      else
        total_monto_ventas = ventas_bruto_mes
      end

      suma_canon_fijo += canon_fijo
      suma_canon_variable += canon_variable
      suma_total_canon += total_canon
      suma_venta_neta += venta_neta_mes
      suma_total_ventas += total_monto_ventas
      hash_stats = Hash.new
      hash_stats[:tienda] = tienda
      hash_stats[:tipo_canon] = tipo_canon
      hash_stats[:editable] = editable
      hash_stats[:venta_mes] = venta_mes
      hash_stats[:venta_neta_mes] = venta_neta_mes
      hash_stats[:ventas_bruto_mes] = ventas_bruto_mes
      hash_stats[:canon_fijo] = canon_fijo
      hash_stats[:canon_variable] = canon_variable
      hash_stats[:total_canon] = total_canon
      hash_stats[:tiene_cobranza_mes] = tiene_cobranza_alquiler
      hash_stats[:suma_ventas_tiendas] = suma_ventas_tiendas
      hash_stats[:total_monto_ventas] = total_monto_ventas
      hash_stats[:suma_ventas_bruto_tiendas] = suma_ventas_bruto_tiendas
      hash_stats[:suma_venta_neta] = suma_venta_neta
      hash_stats[:suma_canon_fijo] = suma_canon_fijo
      hash_stats[:suma_canon_variable] = suma_canon_variable
      hash_stats[:suma_total_canon] = suma_total_canon
      hash_stats[:suma_total_ventas] = suma_total_ventas

      ventas << hash_stats
    end
    return ventas
  end

  #TODO MOVER A UN LUGAR MAS ADECUADO
  def self.estadisticas(mall, fecha_init, fecha_end, nivel_mall_id, actividad_economica_id, tipo_local_id, criterio )
    estadisticas = Array.new
    if criterio == 'tiendas'
      mall.tiendas.joins(:nivel_mall, :actividad_economica, :tipo_local, :contrato_alquilers).by_actividad_economica(actividad_economica_id).by_nivel_mall(nivel_mall_id).by_rango_contrato(fecha_init, fecha_end).by_tipo_local(tipo_local_id).each do |tienda|
        puts tienda
        hash_stats = Hash.new
        hash_stats[:venta_diaria] = tienda.venta_diariums.where(fecha: fecha_init.. fecha_end).sum(:monto_bruto)
        hash_stats[:canon_fijo_ml] = tienda.cobranza_alquilers.where(fecha_recibo_cobro: fecha_init.. fecha_end).sum(:monto_canon_fijo)
        hash_stats[:porc_canon] = tienda.cobranza_alquilers.where(fecha_recibo_cobro: fecha_init.. fecha_end).sum(:monto_canon_variable)
        hash_stats[:total] = hash_stats[:canon_fijo_ml] + hash_stats[:porc_canon]
        hash_stats[:criterio] = tienda.nombre
        estadisticas << hash_stats
      end
    elsif criterio == 'nivel_mall'
      mall.nivel_mall_stats(nivel_mall_id).each do |nivel_mall|
        canon_fijo = 0
        porc_canon = 0
        ventas = 0
        total = 0
        nivel_mall.tiendas.joins(:nivel_mall, :actividad_economica, :tipo_local, :contrato_alquilers).by_nivel_mall(nivel_mall_id).by_actividad_economica(actividad_economica_id).by_rango_contrato(fecha_init, fecha_end).by_tipo_local(tipo_local_id).each do |tienda|
          ventas = ventas + tienda.venta_diariums.where(fecha: fecha_init.. fecha_end).sum(:monto_bruto)
          canon_fijo = canon_fijo + tienda.cobranza_alquilers.where(fecha_recibo_cobro: fecha_init.. fecha_end).sum(:monto_canon_fijo)
          porc_canon = porc_canon + tienda.cobranza_alquilers.where(fecha_recibo_cobro: fecha_init.. fecha_end).sum(:monto_canon_variable)
          total = canon_fijo+ porc_canon
        end
        hash_stats = Hash.new
        hash_stats[:canon_fijo_ml] = canon_fijo
        hash_stats[:porc_canon] = porc_canon
        hash_stats[:total] = total
        hash_stats[:criterio] = nivel_mall.nombre
        hash_stats[:venta_diaria] = ventas
        estadisticas << hash_stats
      end
    elsif criterio == 'actividad_economica'
      mall.actividad_economicas_stats(actividad_economica_id).each do |actividad_economica|
        canon_fijo = 0
        porc_canon = 0
        ventas = 0
        total = 0
        actividad_economica.tiendas.joins(:nivel_mall, :actividad_economica, :tipo_local, :contrato_alquilers).by_nivel_mall(nivel_mall_id).by_actividad_economica(actividad_economica_id).by_rango_contrato(fecha_init, fecha_end).by_tipo_local(tipo_local_id).each do |tienda|
          canon_fijo = canon_fijo + tienda.cobranza_alquilers.where(fecha_recibo_cobro: fecha_init.. fecha_end).sum(:monto_canon_fijo)
          porc_canon = porc_canon + tienda.cobranza_alquilers.where(fecha_recibo_cobro: fecha_init.. fecha_end).sum(:monto_canon_variable)
          total = canon_fijo + porc_canon
          ventas = ventas + tienda.venta_diariums.where(fecha: fecha_init.. fecha_end).sum(:monto_bruto)
        end
        hash_stats = Hash.new
        hash_stats[:canon_fijo_ml] = canon_fijo
        hash_stats[:porc_canon] = porc_canon
        hash_stats[:total] = total
        hash_stats[:venta_diaria] = ventas
        hash_stats[:criterio] = actividad_economica.nombre

        estadisticas << hash_stats
      end
    elsif criterio == 'tipo_local'
      mall.tipo_locals_stats(tipo_local_id).each do |tipo_local|
        canon_fijo = 0
        porc_canon = 0
        ventas = 0
        total = 0
        tipo_local.tiendas.joins(:nivel_mall, :actividad_economica, :tipo_local, :contrato_alquilers).by_nivel_mall(nivel_mall_id).by_actividad_economica(actividad_economica_id).by_rango_contrato(fecha_init, fecha_end).by_tipo_local(tipo_local_id).each do |tienda|
          canon_fijo = canon_fijo + tienda.cobranza_alquilers.where(fecha_recibo_cobro: fecha_init.. fecha_end).sum(:monto_canon_fijo)
          porc_canon = porc_canon + tienda.cobranza_alquilers.where(fecha_recibo_cobro: fecha_init.. fecha_end).sum(:monto_canon_variable)
          total = canon_fijo + porc_canon
          ventas = ventas + tienda.venta_diariums.where(fecha: fecha_init.. fecha_end).sum(:monto_bruto)
        end
        hash_stats = Hash.new
        hash_stats[:canon_fijo_ml] = canon_fijo
        hash_stats[:porc_canon] = porc_canon
        hash_stats[:total] = total
        hash_stats[:criterio] = tipo_local.tipo
        hash_stats[:venta_diaria] = ventas
        estadisticas << hash_stats
      end
    end
    return estadisticas
  end


  def self.estadisticas_mensuales(mall, year) # Este método está dando los resultados incorrectos
    estadisticas = Array.new
    (1 .. 12).each do |mes|
      hash_stats = Hash.new
      canon_fijo = 0
      porc_canon = 0
      ventas = 0
      mall.tiendas.joins(:contrato_alquilers, :venta_diariums).where("extract(year from contrato_alquilers.fecha_fin) = ? OR extract(year from contrato_alquilers.fecha_inicio) = ?", year, year).where("extract(year from venta_diaria.fecha) = ? ", year).each do |tienda|
        ventas = tienda.venta_mensuals.where(anio: year, mes: mes).sum(:monto_bruto)
        canon_fijo = tienda.cobranza_alquilers.where("extract(month from fecha_recibo_cobro) = ?", mes).sum(:monto_canon_fijo)
        porc_canon = tienda.cobranza_alquilers.where("extract(month from fecha_recibo_cobro) = ?", mes).sum(:monto_canon_variable)
      end
      hash_stats[:mes] = mes
      hash_stats[:venta_diaria] = ventas
      hash_stats[:canon_fijo_ml] = canon_fijo
      hash_stats[:porc_canon] = porc_canon
      hash_stats[:total] = hash_stats[:canon_fijo_ml] + hash_stats[:porc_canon]
      estadisticas << hash_stats
    end
    return estadisticas
  end
end
