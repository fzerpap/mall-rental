class EstadoFactura < ActiveRecord::Base
  belongs_to :factura_alquiler

  # enum estado_factura: [:Por_Cobrar, :Cobrada, :Nula]
end
