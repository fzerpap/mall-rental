class AddEstadoFacturaToFacturaAlquiler < ActiveRecord::Migration
  def change
    add_reference :factura_alquilers, :estado_factura, index: true
  end
end
