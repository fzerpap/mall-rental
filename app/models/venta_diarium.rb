# == Schema Information
#
# Table name: venta_diaria
#
#  id                  :integer          not null, primary key
#  fecha               :date
#  monto               :float
#  monto_notas_credito :float            default(0.0)
#  monto_bruto         :float
#  monto_bruto_usd     :float
#  monto_costo_venta   :float            default(0.0)
#  monto_neto          :float            default(0.0)
#  monto_neto_usd      :float            default(0.0)
#  editable            :boolean          default(TRUE)
#  venta_mensual_id    :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class VentaDiarium < ActiveRecord::Base
  belongs_to :venta_mensual

  def self.get_ventas_diaria_tienda(venta_mensual)
    return self.where('venta_mensual_id = ?',venta_mensual) || nil
  end

  def self.get_ventas_diarias_tienda(tienda,year,mes)
    venta_mensual = VentaMensual.get_venta_mes_tienda(tienda,year,mes)
    if !venta_mensual.nil?
      return self.where('venta_mensual_id = ?',venta_mensual) || nil
    end
  end

  def self.get_venta_dia_tienda(fecha,venta_mensual)
    find_by('fecha = ? AND venta_mensual_id = ?', fecha,venta_mensual.id)
  end

  def self.cantidad_ventas_mes(year,mes,tienda)
    venta_mensual = VentaMensual.get_venta_mes_tienda(tienda,year,mes)
    if venta_mensual.nil?
      return 0
    else
      return self.where('extract(year from fecha) = ? AND extract(month from fecha) = ? AND venta_mensual_id = ?', year,mes,venta_mensual.id).count()
    end
  end

  def self.suma_ventas_diarias(venta_mensual)
    return self.where('venta_mensual_id = ?', venta_mensual).sum(:monto)
  end

  def self.suma_notas_credito(venta_mensual)
    return self.where('venta_mensual_id = ?', venta_mensual).sum(:monto_notas_credito)
  end

  def self.suma_costo_venta(venta_mensual)
    return self.where('venta_mensual_id = ?', venta_mensual).sum(:monto_costo_venta)
  end

  def self.cerrar_mes_ventas(venta_mensual)
    result = 0
    venta_diaria = get_ventas_diaria_tienda(venta_mensual)
    if !venta_diaria.blank?
      venta_diaria.each do |venta|
        vent = venta.update(editable: false)
        result = 1
      end
    end
    return result
  end


end
