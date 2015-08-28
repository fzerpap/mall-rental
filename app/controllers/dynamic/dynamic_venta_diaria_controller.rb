module Dynamic
  class DynamicVentaDiariaController < ApplicationController

    respond_to :json

    def venta
      year = params[:year]
      month = params[:month]
      tienda_id = params[:tienda_id]

      tienda = Tienda.find_by(id: tienda_id)

      today = Time.now
      if (month == today.strftime("%-m") && year == today.strftime("%Y"))
        dias_mes =  today.strftime("%d").to_i
        mes_actual = true
      else
        dias_mes = Time.days_in_month(month.to_i, year.to_i)
        mes_actual = false
      end

      ventas_mes = set_grid_ventas_mes(tienda,year,month,dias_mes)
      cant_dias_no_lab = CalendarioNoLaborable.cantidad_dias_no_lab(tienda.mall.id,month,year)

      monto_bruto = VentaMensual.get_montos_venta_mes(tienda_id,year,month)[:monto_bruto]

      cantidad_ventas_mes = VentaDiarium.cantidad_ventas_mes(month,year,tienda)

      render json: [ventas: ventas_mes, result: true, monto_bruto: monto_bruto, tienda_id: tienda_id, dias_no_lab: cant_dias_no_lab, cantidad_ventas_mes: cantidad_ventas_mes, dias_mes: dias_mes, mes_actual:mes_actual]
    end

    def guardar_ventas

      fecha = params[:fecha]
      valor = params[:valor]
      if params[:nota_credito].nil?
        nota_credito = 0
      else
        nota_credito = params[:nota_credito]
      end

      if params[:costo_venta].nil?
        costo_venta = 0
      else
        costo_venta = params[:costo_venta]
      end

      valor_bruto = valor.to_f - nota_credito.to_f
      venta_neta = valor_bruto - costo_venta.to_f
      valor_usd = valor_bruto.to_f / CambioMoneda.last.cambio_ml_x_usd
      venta_neta_usd = venta_neta.to_f / CambioMoneda.last.cambio_ml_x_usd

      id = params[:identificador]
      opcion = params[:opcion]
      tienda_id = params[:tienda_id]
      year = params[:year]
      month = params[:month]

      venta_mensual = VentaMensual.get_venta_mes_tienda(tienda_id,year,month)
      suma_venta, suma_notas_credito, monto_bruto, monto_bruto_usd, suma_costo_venta, suma_venta_neta, suma_neto_usd = 0

      if venta_mensual.blank?
        venta_mensual = VentaMensual.new(anio: year, mes: month, monto: suma_venta, monto_notas_credito: suma_notas_credito, monto_bruto: monto_bruto, monto_bruto_USD: monto_bruto_usd, monto_costo_venta: suma_costo_venta, monto_neto: suma_venta_neta, monto_neto_USD: suma_neto_usd, tienda_id: tienda_id)
        if venta_mensual.save
          id_mensual = venta_mensual.id
        end
      else
        id_mensual = venta_mensual.id
        suma_venta = VentaMensual.suma_venta_mes(tienda_id,year,month)
        suma_notas_credito = VentaMensual.suma_notas_credito_mes(tienda_id,year,month)
        suma_costo_venta = VentaMensual.suma_costo_venta_mes(tienda_id,year,month)
        monto_bruto = suma_venta - suma_notas_credito
        monto_bruto_usd = monto_bruto / CambioMoneda.last.cambio_ml_x_usd
        suma_venta_neta = monto_bruto - suma_costo_venta
        suma_neto_usd = suma_venta_neta / CambioMoneda.last.cambio_ml_x_usd
      end

      if opcion == 'new'
        venta = VentaDiarium.new(fecha: fecha, monto: valor, monto_notas_credito: nota_credito, monto_bruto: valor_bruto, monto_bruto_usd: valor_usd, monto_costo_venta: costo_venta, monto_neto: venta_neta, monto_neto_usd: venta_neta_usd, venta_mensual_id: id_mensual)

        respond_to do |format|
          if venta.save

            suma_venta = VentaDiarium.suma_ventas_diarias(id_mensual)
            suma_notas_credito = VentaDiarium.suma_notas_credito(id_mensual)
            suma_costo_venta = VentaDiarium.suma_costo_venta(id_mensual)
            monto_bruto = suma_venta - suma_notas_credito
            monto_bruto_usd = monto_bruto / CambioMoneda.last.cambio_ml_x_usd
            suma_venta_neta = monto_bruto - suma_costo_venta
            suma_neto_usd = suma_venta_neta / CambioMoneda.last.cambio_ml_x_usd

            venta_mens = VentaMensual.find(id_mensual)
            venta_mens.update(monto: suma_venta, monto_notas_credito: suma_notas_credito, monto_bruto: monto_bruto, monto_bruto_USD: monto_bruto_usd, monto_costo_venta: suma_costo_venta, monto_neto: suma_venta_neta, monto_neto_USD: suma_neto_usd)
            format.json { render json: [data: venta, result: true] }
          else
            render json: [data: venta, result: false]
          end
        end
      else
        venta = VentaDiarium.find(params[:identificador])
        respond_to do |format|
          if venta.update( monto: valor, monto_notas_credito: nota_credito, monto_bruto: valor_bruto, monto_bruto_usd: valor_usd, monto_costo_venta: costo_venta, monto_neto: venta_neta, monto_neto_usd: venta_neta_usd)
            suma_venta = VentaDiarium.suma_ventas_diarias(id_mensual)
            suma_notas_credito = VentaDiarium.suma_notas_credito(id_mensual)
            suma_costo_venta = VentaDiarium.suma_costo_venta(id_mensual)
            monto_bruto = suma_venta - suma_notas_credito
            monto_bruto_usd = monto_bruto / CambioMoneda.last.cambio_ml_x_usd
            suma_venta_neta = monto_bruto - suma_costo_venta
            suma_neto_usd = suma_venta_neta / CambioMoneda.last.cambio_ml_x_usd

            venta_mens = VentaMensual.find(id_mensual)
            venta_mens.update(monto: suma_venta, monto_notas_credito: suma_notas_credito, monto_bruto: monto_bruto, monto_bruto_USD: monto_bruto_usd, monto_costo_venta: suma_costo_venta, monto_neto: suma_venta_neta, monto_neto_USD: suma_neto_usd)
            format.json { render json: [data: venta, result: true] }
          else
            render json: [data: venta, result: false]
          end
        end
      end
    end


    def cerrar_ventas_mes
      year = params[:year]
      month = params[:month]
      tienda_id = params[:tienda]

      venta_mensual = VentaMensual.get_venta_mes_tienda(tienda_id,year,month)
      if !venta_mensual.nil?
        if venta_mensual.editable
          venta_mensual.update(editable: false)
          result = VentaDiarium.cerrar_mes_ventas(venta_mensual.id)
          else
          result = 2
        end
      else
        result = 3
      end

      render json: [data: venta_mensual, result: result]
    end

    def crear_objeto(id,dia,fecha,monto,monto_notas_credito,monto_venta_bruta,monto_costo_venta,monto_venta_neta,editable,no_laborable)
      obj = {
          'id' => id,
          'dia' => dia,
          'fecha' => fecha,
          'monto' =>  monto,
          'monto_notas_credito' =>  monto_notas_credito,
          'monto_venta_bruta' =>  monto_venta_bruta,
          'monto_costo_venta' => monto_costo_venta,
          'monto_venta_neta' => monto_venta_neta,
          'editable' => editable,
          'no_laborable' => no_laborable,
      }
      return obj
    end

    def set_grid_ventas_mes(tienda,year,month,dias_mes)
      venta_mensual = VentaMensual.get_venta_mes_tienda(tienda,year,month)
      ventas_mes = Array.new
      for i in 1..dias_mes
        monto_notas_c = 0
        fecha = Date.new(year.to_i,month.to_i,i)
        dia_no_lab = CalendarioNoLaborable.is_no_lab(fecha,tienda.mall.id)
        if !venta_mensual.blank?
          ventas_dia = VentaDiarium.get_venta_dia_tienda(fecha,venta_mensual)

          editable = false if !venta_mensual.editable

          if !ventas_dia.blank?
            monto_notas_c = ventas_dia.monto_notas_credito if !ventas_dia.monto_notas_credito.nil?
            venta_bruta = ventas_dia.monto - (monto_notas_c || 0)
            ventas_dia.monto_costo_venta = 0 if ventas_dia.monto_costo_venta.nil?
            venta_neta = venta_bruta - ventas_dia.monto_costo_venta
            editable = ventas_dia.editable if venta_mensual.editable

            obj = crear_objeto(ventas_dia.id,i,ventas_dia.fecha.strftime("%d/%m/%Y"),ventas_dia.monto,monto_notas_c,venta_bruta,ventas_dia.monto_costo_venta,venta_neta,editable,false)
          else
            if !dia_no_lab.blank?
              monto = 'Dia No Laborable: '+dia_no_lab.motivo
              editable = false
              no_laborable = true
            else
              monto = ''
              editable = true if venta_mensual.editable
              no_laborable = false
            end
            obj = crear_objeto(-1,i,fecha.strftime("%d/%m/%Y"),monto,'','','','',editable,no_laborable)
          end
        else
          if !dia_no_lab.blank?
            monto = 'Dia No Laborable: '+dia_no_lab.motivo
            editable = false
            no_laborable = true
          else
            monto = ''
            editable = true
            no_laborable = false
          end
          obj = crear_objeto(-1,i,fecha.strftime("%d/%m/%Y"),monto,'','','','',editable,no_laborable)
        end
        ventas_mes.push(obj)
      end
      return ventas_mes
    end
  end
end