module Dynamic
  class DynamicPagoAlquilersController < ApplicationController
    respond_to :json

    def recibos_cobro
      tiendas = params[:tiendas]
      year = params[:year]
      month = params[:month]
      tiendas_id = Array.new
      ventas_tiendas = Array.new
      result = false
      tiendas.each do |tienda_id|
        contrato_alquiler = ContratoAlquiler.get_contrato_vigente_fecha(tienda_id,year,month)

        nro_rec = NroRecibosCobro.get_numero_recibo.to_s
        nro_recibo = nro_rec.to_s.rjust(4, '0')
        fecha_recibo = Date.today

        venta_mensual = VentaMensual.get_venta_mes_tienda(tienda_id,year,month)

        venta_monto_bruto = venta_mensual.monto_bruto
        venta_monto_neto  = venta_mensual.monto_neto

        monto_canon_variable = contrato_alquiler.calcular_canon_variable_ml(venta_monto_bruto,venta_monto_neto)

        monto_canon_fijo = contrato_alquiler.canon_fijo_ml
        monto_alquiler = monto_canon_fijo + monto_canon_variable
        monto_alquiler_usd = monto_alquiler/CambioMoneda.last.cambio_ml_x_usd
        pagado = false

        cobranza = CobranzaAlquiler.new(nro_recibo: nro_recibo, fecha_recibo_cobro: fecha_recibo,
                           anio_alquiler: year, mes_alquiler: month,
                           monto_canon_fijo: monto_canon_fijo, monto_canon_variable: monto_canon_variable,
                           monto_alquiler: monto_alquiler, monto_alquiler_usd: monto_alquiler_usd, saldo_deudor: monto_alquiler,
                           tienda_id: tienda_id)
        if cobranza.save
          result = true
          if monto_canon_fijo > 0
            nro_factura = NroFactura.get_numero_factura
            factura = FacturaAlquiler.new(fecha: fecha_recibo, nro_factura: nro_factura, monto_factura: monto_canon_fijo,
                                            saldo_deudor: monto_canon_fijo, canon_fijo: true, cobranza_alquiler_id: cobranza.id)
            factura.save
          end
          if monto_canon_variable > 0
            nro_factura1 = NroFactura.get_numero_factura
            factura1 = FacturaAlquiler.new(fecha: fecha_recibo, nro_factura: nro_factura1, monto_factura: monto_canon_variable,
                                           saldo_deudor: monto_canon_variable, canon_fijo: false, cobranza_alquiler_id: cobranza.id)
            factura1.save
          end
        end
        ventas_tiendas.push(result)
      end
      render json: [result: result, tiendas: tiendas, ventas_tiendas: ventas_tiendas]
    end

    def mf_facturas_tiendas
      @tienda_id = params[:tienda_id]
      render json: [id: @tienda_id]
    end
  end
end
