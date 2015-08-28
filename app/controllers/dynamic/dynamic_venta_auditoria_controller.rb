module Dynamic
  class DynamicVentaAuditoriaController < ApplicationController
    respond_to :json

    def auditoria
      year = params[:year]
      month = params[:month]
      cob = CobranzaAlquiler.get_gestion_cobranza(current_user.mall,year,month)
      #obj = obj
      array_tienda = Array.new
      cant = cob.count()-1
      (0..cant).each do |pos|
        tienda = Tienda.find(cob[pos][:tienda])
        auditoria = {
            tienda_id: cob[pos][:tienda],tienda: tienda.nombre,actividad_economica: tienda.actividad_economica.nombre,
            local: tienda.local.nro_local,nivel_ubicacion: tienda.local.nivel_mall.nombre,
            tipo_canon: cob[pos][:tipo_canon],
            canon_fijo: ActionController::Base.helpers.number_to_currency(cob[pos][:canon_fijo], separator: ',', delimiter: '.', format: "%n %u", unit: ""),
            canon_variable: ActionController::Base.helpers.number_to_currency(cob[pos][:canon_variable], separator: ',', delimiter: '.', format: "%n %u", unit: ""),
            venta_mes: ActionController::Base.helpers.number_to_currency(cob[pos][:venta_mes], separator: ',', delimiter: '.', format: "%n %u", unit: ""),
            canon_alquiler: ActionController::Base.helpers.number_to_currency(cob[pos][:canon_alquiler], separator: ',', delimiter: '.', format: "%n %u", unit: ""),
            recibos_cobro:cob[pos][:tiene_cobranza],
            venta_neta: ActionController::Base.helpers.number_to_currency(cob[pos][:venta_neta], separator: ',', delimiter: '.', format: "%n %u", unit: ""),
            venta_bruta:  ActionController::Base.helpers.number_to_currency(cob[pos][:venta_bruta], separator: ',', delimiter: '.', format: "%n %u", unit: ""),
            editable: cob[pos][:editable]
        }
        array_tienda << auditoria
      end

      total_ventas = ActionController::Base.helpers.number_to_currency(cob[cant][:total_ventas], separator: ',', delimiter: '.', format: "%n %u", unit: "")
      total_canon_fijo = ActionController::Base.helpers.number_to_currency(cob[cant][:total_canon_fijo], separator: ',', delimiter: '.', format: "%n %u", unit: "")
      total_canon_variable = ActionController::Base.helpers.number_to_currency(cob[cant][:total_canon_variable], separator: ',', delimiter: '.', format: "%n %u", unit: "")
      total_canon = ActionController::Base.helpers.number_to_currency(cob[cant][:total_canon], separator: ',', delimiter: '.', format: "%n %u", unit: "")

      render json: [ result: true, tiendas: array_tienda, total_canon_variable: total_canon_variable, total_canon_fijo: total_canon_fijo, total_canon: total_canon, total_ventas: total_ventas, mes: month ]


    end
  end
end