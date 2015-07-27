class CreateContratoServicios < ActiveRecord::Migration
  def change
    create_table :contrato_servicios do |t|
      t.string :nro_contrato
      t.date :fecha_inicio
      t.date :fecha_fin
      t.string :archivo_contrato
      t.float :monto_ml, precision: 12, scale: 2
      t.float :monto_usd, precision: 12, scale: 2
      t.float :porc_ingresos_alquiler, default: 0, precision: 12, scale: 2
      t.boolean :estado_contrato, default: true
      t.integer :locatarios, default: 0
      t.boolean :contrato_ml, default: true
      t.references :precio_servicio, index: true
      t.references :tipo_contrato_servicio, index: true
      t.references :cliente, index: true
      t.timestamps
    end
  end
end
