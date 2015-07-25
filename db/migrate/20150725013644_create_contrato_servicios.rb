class CreateContratoServicios < ActiveRecord::Migration
  def change
    create_table :contrato_servicios do |t|
      t.string :nro_contrato
      t.date :fecha_inicio
      t.date :fecha_fin
      t.string :archivo_contrato
      t.float :monto_ml
      t.float :moonto_usd
      t.float :porcIngresosAlquiler
      t.boolean :estado_contrato
      t.integer :locatarios
      t.boolean :contrato_ml

      t.timestamps
    end
  end
end
