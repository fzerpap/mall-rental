class CreateEstadoFacturas < ActiveRecord::Migration
  def change
    create_table :estado_facturas do |t|
      t.string :estado

      t.timestamps
    end
  end
end
