class FacturaAlquiler < ActiveRecord::Base
  has_many :detalle_pago_alquilers
  has_many :pago_alquilers, through: :detalle_pago_alquilers
  belongs_to :cobranza_alquiler

  enum estado_factura: [:Por_Cobrar, :Cobrada, :Nula]
end
