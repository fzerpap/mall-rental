module Dynamic
  class DynamicVentasMesController < ApplicationController
    respond_to :json
    def ventas
      year = params[:year]
      mall = current_user.mall

      # Obtiene las cobranzas y las ventas x mes
      cobranzas = CobranzaAlquiler.get_cobranzas_xmes(mall,year)
      ventas    = VentaMensual.get_ventas_xmes(mall,year)

      # inicializa valores
      array_venta_ycanon = Array.new
      total_ventas = total_canon_fijo = total_canon_variable = total_canon = i = 0
      meses = ['Enero', 'Febrero', 'Marzo', 'Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']

      # Une las ventas con las cobranznas (conones de alquiler)
      ventas.each do |venta|
        canon_fijo     = cobranzas[i] != nil ? cobranzas[i][:monto_canon_fijo]: 0
        canon_variable = cobranzas[i] != nil ? cobranzas[i][:monto_canon_variable]: 0
        canon_total    = canon_fijo + canon_variable

        venta_ycanon = {mes: meses[venta.mes - 1],
            monto_ventas: ActionController::Base.helpers.number_to_currency(venta.monto_bruto, separator: ',', delimiter: '.', format: "%n %u", unit: ""),
            canon_fijo: ActionController::Base.helpers.number_to_currency(canon_fijo, separator: ',', delimiter: '.', format: "%n %u", unit: ""),
            canon_variable: ActionController::Base.helpers.number_to_currency(canon_variable, separator: ',', delimiter: '.', format: "%n %u", unit: ""),
            canon_total: ActionController::Base.helpers.number_to_currency(canon_total, separator: ',', delimiter: '.', format: "%n %u", unit: "")
            }
        array_venta_ycanon << venta_ycanon

        i += 1
        total_ventas         += venta.monto_bruto
        total_canon_fijo     += canon_fijo
        total_canon_variable += canon_variable
        total_canon          += canon_total
      end
      # Formateando los totales
      total_ventas         = ActionController::Base.helpers.number_to_currency(total_ventas, separator: ',', delimiter: '.', format: "%n %u", unit: "")
      total_canon_fijo     = ActionController::Base.helpers.number_to_currency(total_canon_fijo, separator: ',', delimiter: '.', format: "%n %u", unit: "")
      total_canon_variable = ActionController::Base.helpers.number_to_currency(total_canon_variable, separator: ',', delimiter: '.', format: "%n %u", unit: "")
      total_canon          = ActionController::Base.helpers.number_to_currency(total_canon, separator: ',', delimiter: '.', format: "%n %u", unit: "")

      render json: [ventas: array_venta_ycanon, result: true, total_ventas: total_ventas, total_canon_fijo: total_canon_fijo, total_canon_variable: total_canon_variable, total_canon: total_canon, meses: i]
    end
  end
end