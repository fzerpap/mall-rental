class FacturaAlquiler < ActiveRecord::Base
  has_many :detalle_pago_alquilers
  has_many :pago_alquilers, through: :detalle_pago_alquilers
  belongs_to :cobranza_alquiler

  has_one :estado_factura

  def self.get_facturas_xcobrar_tienda(tienda)
    return self.where("estado_factura_id = ?", 'Por_Cobrar')

  end

  def self.get_facturas_x_pagar
    return self.where("saldo_deudor > ?", 0)
  end

  def self.get_total_facturado(tienda)
    return CobranzaAlquiler.where("tienda_id = ? AND saldo_deudor > ?", tienda, 0).sum(:monto_alquiler)
  end
end
