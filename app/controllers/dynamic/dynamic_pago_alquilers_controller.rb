module Dynamic
  class DynamicPagoAlquilersController < ApplicationController
    respond_to :json

    def recibos_cobro
      @tiendas = params[:tiendas]
      @year = params[:year]
      @month = params[:month]
      @tiendas_id = Array.new
      @ventas_tiendas = Array.new
      @tiendas.each do |tienda|
        @tiend = Tienda.where(id: tienda)
        @contrato_alquiler = ContratoAlquiler.find_by(tienda: tienda)
        @contrato_a = ContratoAlquiler.find_by(tienda: tienda)
        @tipo_canon = @contrato_alquiler.tipo_canon_alquiler.humanize.capitalize


        @nro_recibo = NroRecibo.get_numero_recibo.to_s
        @nro_recibo = @nro_recibo.to_s.rjust(4, '0')

        @fecha_recibo = Date.today
        @anio_alquiler = @year
        @mes_alquiler = @month

        @canons = @contrato_alquiler.calculate_canon(@contrato_a,@suma_ventas_mes)
        @monto_canon_fijo_ml = @canons['canon_fijo']
        @monto_porc_ventas = @canons['canon_x_ventas']
        @monto_alquiler = @canons['canon_alquiler']
        @monto_alquiler_usd = @monto_alquiler/CambioMoneda.last.cambio_ml_x_usd
        @pagado = false

        @pago = PagoAlquiler.new(nro_recibo: @nro_recibo, fecha_recibo_cobro: @fecha_recibo,
                           anio_alquiler: @anio_alquiler, mes_alquiler: @mes_alquiler,
                           monto_canon_fijo_ml: @monto_canon_fijo_ml, monto_porc_ventas_ml: @monto_porc_ventas,
                           monto_alquiler_ml: @monto_alquiler, monto_alquiler_usd: @monto_alquiler_usd, pagado: @pagado,
                           tienda_id: tienda)
        if @pago.save
          @result = true
        end

        @ventas = Venta.where('extract(year from fecha) = ? AND extract(month from fecha ) = ? AND tienda_id = ?', @year,@month,tienda)
        @ventas.each do |venta|
          if venta.update(editable: false)
            @result = true
          end
        end

        @ventas_tiendas.push(@result)
      end
      render json: [data: @ventas, result: @result, tiendas: @tiendas, ventas_tiendas: @ventas_tiendas]
    end

    def actualizar_pagos
      @year = params[:year]
      @month = params[:month]
      @suma_x_cobrar = 0
      @suma_monto_pagado = 0
      @suma_monto_alquiler = 0
      @tiendas = current_user.mall.tiendas
      @pago_alquilers = Array.new
      @tiendas.each do |tienda|
        @pago_alq = PagoAlquiler.find_by('extract(year from fecha_recibo_cobro) = ? AND extract(month from fecha_recibo_cobro) = ? AND tienda_id = ?', @year,@month,tienda.id)

        if !@pago_alq.blank?
          if @pago_alq.cuenta_bancaria_id.nil?
            @cuenta_bancaria = ''
          else
            @cuenta_bancaria = CuentaBancarium.find(@pago_alq.cuenta_bancaria_id).banco.nombre
          end

          if @pago_alq.tipo_pago.nil?
            @tipo_pago = ''
          else
            @tipo_pago = @pago_alq.tipo_pago.humanize.capitalize
          end

          if @pago_alq.pagado
            @mont = @pago_alq.monto_alquiler_ml
            @suma_monto_pagado += @mont
          else
            @mont = 0
            @suma_x_cobrar +=  @pago_alq.monto_alquiler_ml
          end
          @monto_alquiler = @pago_alq.monto_alquiler_ml
          @suma_monto_alquiler += @monto_alquiler

          @obj = {
              'tienda' => tienda.nombre,
              'tipo_pago' => @tipo_pago,
              'monto_pagado' => ActionController::Base.helpers.number_to_currency(@mont, separator: ',', delimiter: '.', format: "%n %u", unit: ""),
              'monto_alquiler' => ActionController::Base.helpers.number_to_currency(@monto_alquiler, separator: ',', delimiter: '.', format: "%n %u", unit: ""),
              'pago' => @pago_alq,
              'banco' => @cuenta_bancaria,
          }
          @pago_alquilers.push(@obj)
        end
      end


      if @pago_alquilers.blank?
        @cont = 0
      else
        @cont = @pago_alquilers.count
      end

      @suma = ActionController::Base.helpers.number_to_currency(@suma_monto_alquiler, separator: ',', delimiter: '.', format: "%n %u", unit: "")
      @suma_x_cobrar = ActionController::Base.helpers.number_to_currency(@suma_x_cobrar, separator: ',', delimiter: '.', format: "%n %u", unit: "")
      @suma_monto_pagado = ActionController::Base.helpers.number_to_currency(@suma_monto_pagado, separator: ',', delimiter: '.', format: "%n %u", unit: "")
      render json: [pago_alquilers: @pago_alquilers, result: true, suma: @suma, cont: @cont, suma_x_cobrar: @suma_x_cobrar, suma_monto_pagado: @suma_monto_pagado]
    end
  end
end
