module Dynamic
  class DynamicVentasMesController < ApplicationController
    respond_to :json
    def ventas
      @year = params[:year]
      @mall = current_user.mall
      @suma_total = 0
      @total_canon_fijo = 0
      @total_canon_x_ventas = 0
      @today = Time.now
      if (@month == @today.strftime("%-m") && @year == @today.strftime("%Y"))
        @dias_mes =  @today.strftime("%d").to_i
      else
        @dias_mes = Time.days_in_month(@month.to_i, @year.to_i)
      end

      @ventas_mes = Array.new
      @tiendas_mall = Mall.find(current_user.mall).tiendas
      for i in 1..12
        @k = i.to_s
        #@ventas = Mall.find(current_user.mall).tiendas.first.ventas.where('extract(year from fecha) = ? AND extract(month from fecha) = ?', @year, @k).sum(:monto_ml)
        @suma = 0
        @canon_fijo = 0
        @canon_x_ventas = 0
        @total_mes_canon = 0
        @tiendas_mall.each do |tienda|
          @ventas = tienda.ventas.where('extract(year from fecha) = ? AND extract(month from fecha) = ?', @year, @k).sum(:monto_ml)
          if @ventas > 0
            @suma += @ventas
          end
          @contratos = tienda.contrato_alquilers.where(:estado_contrato => true)
          if !@contratos.first.canon_fijo_ml.nil?
            @canon_fijo += @contratos.first.canon_fijo_ml
          else
            @canon_fijo = 0
          end
          if !@contratos.first.porc_canon_ventas.nil?
            @canon_x_ventas += (@contratos.first.porc_canon_ventas * @ventas)
          end
          @total_mes_canon = @canon_fijo + @canon_x_ventas

          @obj = {
              'ventas' => ActionController::Base.helpers.number_to_currency(@suma, separator: ',', delimiter: '.', format: "%n %u", unit: ""),
              'canon_fijo' => ActionController::Base.helpers.number_to_currency(@canon_fijo, separator: ',', delimiter: '.', format: "%n %u", unit: ""),
              'canon_x_ventas' => ActionController::Base.helpers.number_to_currency(@canon_x_ventas, separator: ',', delimiter: '.', format: "%n %u", unit: ""),
              'total_mes_canon' => ActionController::Base.helpers.number_to_currency(@total_mes_canon, separator: ',', delimiter: '.', format: "%n %u", unit: ""),
          }
        end
        @ventas_mes.push(@obj)
        @suma_total += @suma
        @total_canon_x_ventas += @canon_x_ventas
        @total_canon_fijo += @canon_fijo
        @suma = ActionController::Base.helpers.number_to_currency(@suma, separator: ',', delimiter: '.', format: "%n %u", unit: "")
        @total_canons = @total_canon_fijo + @total_canon_x_ventas
      end
      @total_canon_x_ventas = ActionController::Base.helpers.number_to_currency(@total_canon_x_ventas, separator: ',', delimiter: '.', format: "%n %u", unit: "")
      @total_canon_fijo = ActionController::Base.helpers.number_to_currency(@total_canon_fijo, separator: ',', delimiter: '.', format: "%n %u", unit: "")
      @suma_total = ActionController::Base.helpers.number_to_currency(@suma_total, separator: ',', delimiter: '.', format: "%n %u", unit: "")
      @total_canons = ActionController::Base.helpers.number_to_currency(@total_canons, separator: ',', delimiter: '.', format: "%n %u", unit: "")
      render json: [ventas: @ventas_mes, result: true, suma_total: @suma_total, total_canon_x_ventas: @total_canon_x_ventas, total_canon_fijo: @total_canon_fijo, total_mes_canon: @total_mes_canon, total_canons: @total_canons]
    end
  end
end