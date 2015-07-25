json.array!(@contrato_servicios) do |contrato_servicio|
  json.extract! contrato_servicio, :id, :nro_contrato, :fecha_inicio, :fecha_fin, :archivo_contrato, :monto_ml, :moonto_usd, :porcIngresosAlquiler, :estado_contrato, :locatarios, :contrato_ml
  json.url contrato_servicio_url(contrato_servicio, format: :json)
end
