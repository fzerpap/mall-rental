# == Schema Information
#
# Table name: venta_mensual
#
#  id                  :integer          not null, primary key
#  anio                :integer
#  mes                 :integer
#  monto               :float
#  monto_notas_credito :float            default(0.0)
#  monto_bruto         :float
#  monto_bruto_USD     :float
#  monto_costo_venta   :float            default(0.0)
#  monto_neto          :float            default(0.0)
#  monto_neto_USD      :float            default(0.0)
#  editable            :boolean          default(TRUE)
#  tienda_id           :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class VentaMensual < ActiveRecord::Base
  belongs_to :tienda
  has_many :venta_diariums
  has_many :documento_ventas

  # Obtien las ventas de una tienda para un mes-año dado
  def self.get_venta_mes_tienda(tienda_id,year,month)
    where(tienda_id: tienda_id, anio: year, mes: month).first
  end

  # Obtien las ventas de cada tienda para un mes-año dado
  def self.get_ventas_mes_xtienda(mall,year,month)
    ids_tiendas = Tienda.get_ids_tiendas_mall(mall)
    where(tienda_id: ids_tiendas, anio: year, mes: month).order(:tienda_id)
  end

  # Obtiene en un hash los montos de la venta mensual, dada la tienda, año y mes
  def self.get_montos_venta_mes(tienda_id,year,month)
    venta_mensual = get_venta_mes_tienda(tienda_id,year,month)
    if venta_mensual.nil?
      return {monto: 0,monto_bruto: 0,monto_neto: 0, monto_notas_credito: 0,monto_costo_venta: 0}
    else
      return {monto: venta_mensual.monto,monto_bruto: venta_mensual.monto_bruto,monto_neto: venta_mensual.monto_neto,
      monto_notas_credito: venta_mensual.monto_notas_credito,monto_costo_venta: venta_mensual.monto_costo_venta}
    end
  end

  def self.suma_venta_mes(tienda_id,year,month)
    venta_mensual = get_venta_mes_tienda(tienda_id,year,month)
    if venta_mensual.nil?
      return 0
    else
      return venta_mensual.monto
    end
  end

  def self.monto_bruto_mes(tienda,year,month)
    venta_mensual = get_venta_mes_tienda(tienda,year,month)
    if venta_mensual.nil?
      return 0
    else
      return venta_mensual.monto_bruto
    end
  end

  def self.monto_neto_mes(tienda,year,month)
    venta_mensual = get_venta_mes_tienda(tienda,year,month)
    if venta_mensual.nil?
      return 0
    else
      return venta_mensual.monto_neto
    end
  end

   def self.suma_monto_bruto(mall,year)
    suma = 0
    mall.tiendas.each do |tienda|
      suma += VentaMensual.where("tienda_id = ? AND anio = ?", tienda, year).sum(:monto_bruto)
      suma = 0 if suma.nil?
    end
    return suma
  end

  def self.suma_notas_credito_mes(tienda,year,month)
    venta_mensual = get_venta_mes_tienda(tienda,year,month)
    if venta_mensual.nil?
      return 0
    else
      return venta_mensual.monto_notas_credito
    end
  end

  def self.suma_costo_venta_mes(tienda,year,month)
    venta_mensual = get_venta_mes_tienda(tienda,year,month)
    if venta_mensual.nil?
      return 0
    else
      return venta_mensual.monto_costo_venta
    end
  end

  def self.get_is_editable(tienda,anio,mes)
    venta_mensual = get_venta_mes_tienda(tienda,anio,mes)
    if venta_mensual.nil?
      return true
    else
      return venta_mensual.editable
    end
  end
  # Obtien las ventas de un mall de cada mes para un año dado
  def self.get_ventas_xmes(mall,year)
    ids_tiendas = mall.tiendas.pluck(:id)
    select("mes,sum(monto_bruto) as monto_bruto").where(tienda_id: ids_tiendas, anio: year).group(:mes).order(:mes)
  end

end
