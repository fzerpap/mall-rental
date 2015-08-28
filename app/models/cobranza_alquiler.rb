class CobranzaAlquiler < ActiveRecord::Base
  belongs_to :tienda
  has_many :factura_alquilers

  def self.get_num_facturas(tienda_id)
    return CobranzaAlquiler.joins(:factura_alquilers).where(tienda_id: tienda_id).count()
  end

  def self.get_facturas_x_pagar(tienda_id)
    cobranza_alquiler = CobranzaAlquiler.where(tienda_id: tienda_id)
    facturas_array = Array.new

    if !cobranza_alquiler.blank?
      cobranza_alquiler.each do |cobranza|
        facturas = cobranza.factura_alquilers.get_facturas_x_pagar
        facturas_array.push(facturas)
      end
      return facturas_array
    else
      return nil
    end
  end

  def self.get_cobranzas(user)
    tiendas = user.mall.tiendas
    cobranzas = Array.new
    tiendas.each do |tienda|
      cobranzas.push(CobranzaAlquiler.joins(:tienda).where(tienda_id: tienda.id))
    end
    return cobranzas
  end

  def self.get_cobranza_mes_xtiendaBORRAR(mall,year,month)
    cobranzas = Array.new
    tiendas = mall.tiendas
    tiendas.each do |tienda|
      cobranza = CobranzaAlquiler.where('anio_alquiler = ? AND mes_alquiler = ? AND tienda_id = ?', year,month,tienda.id)
      if !cobranza.blank?
        cobranzas.push(cobranza)
      end
    end
    return cobranzas
  end

  def self.get_cobranza_mes_tienda(tienda_id,year,month)
      where(tienda_id: tienda_id, anio_alquiler: year, mes_alquiler:month).first
  end

  def self.saldo_deudor_x_tienda(tienda_id)
    return CobranzaAlquiler.where(tienda_id: tienda_id).sum(:saldo_deudor)
  end

  def self.get_canon_fijoBORRAR(tienda,anio,mes)
    cobranza = CobranzaAlquiler.find_by('anio_alquiler = ? AND mes_alquiler = ? AND tienda_id = ?', anio,mes,tienda.id)
    if !cobranza.nil?
      return cobranza.monto_canon_fijo
    else
      return 0
    end

  end

  def self.get_canon_variableBORRAR(tienda,anio, mes)
    cobranza = CobranzaAlquiler.find_by('anio_alquiler = ? AND mes_alquiler = ? AND tienda_id = ?', anio,mes,tienda.id)
    if !cobranza.nil?
      return cobranza.monto_canon_variable
    else
      return 0
    end

  end

  def self.tiene_cobranza(tienda,anio,mes)
    cobranza = CobranzaAlquiler.find_by('anio_alquiler = ? AND mes_alquiler = ? AND tienda_id = ?', anio,mes,tienda.id)
    if !cobranza.nil?
      return true
    else
      return false
    end
  end

  def self.saldo_deudor_x_mes(mall,year,month)
    saldo = 0
    tiendas = mall.tiendas
    tiendas.each do |tienda|
      saldo += CobranzaAlquiler.where('anio_alquiler = ? AND mes_alquiler = ? AND tienda_id = ?', year,month,tienda.id).sum(:saldo_deudor)
    end
    return saldo
  end

  def self.monto_alquiler_x_mes(mall,year,month)
    monto = 0
    tiendas = mall.tiendas
    tiendas.each do |tienda|
      monto += CobranzaAlquiler.where('anio_alquiler = ? AND mes_alquiler = ? AND tienda_id = ?', year,month,tienda.id).sum(:monto_alquiler)
    end
    return monto
  end

  def self.get_cobranza_mes_xtienda(mall,year,month)
    ids_tiendas = mall.tiendas.pluck(:id)
    where(tienda_id: ids_tiendas,anio_alquiler: year, mes_alquiler: month)
  end

  def self.get_total_cobranza_mes(mall,year,month)
    ids_tiendas = mall.tiendas.pluck(:id)
    select("sum(monto_canon_fijo) as monto_canon_fijo,sum(monto_canon_variable) as monto_canon_variable,
    sum(monto_alquiler) as monto_alquiler,sum(saldo_deudor) as saldo_deudor")
    .where(tienda_id: ids_tiendas,anio_alquiler: year,mes_alquiler: month)
  end

  def self.get_total_cobranzas_anio(mall,year)
    ids_tiendas = mall.tiendas.pluck(:id)
    select("sum(monto_canon_fijo) as monto_canon_fijo,sum(monto_canon_variable) as monto_canon_variable,
    sum(monto_alquiler) as monto_alquiler,sum(saldo_deudor) as saldo_deudor,sum(monto_alquiler_usd) as monto_alquiler_usd")
    .where(tienda_id: ids_tiendas,anio_alquiler: year)
  end

  def self.get_cobranza_xmesBORRAR(mall,year)
    today = Time.now
    if today.strftime("%Y") == year
      mes_fin = today.strftime("%-m")
    else
      mes_fin = 12
    end
    cobranzas = Array.new

    meses = ['Enero', 'Febrero', 'Marzo', 'Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']

    (1 .. mes_fin.to_i).each do |mes|
      hash_stats = Hash.new
      canon_fijo = 0
      canon_variable = 0
      facturado = 0
      total_facturado = 0
      pagado = 0
      pagado_usd = 0
      x_cobrar = 0
      total_x_cobrar = 0
      total_pagado = 0
      tiendas_mall = mall.tiendas
      tiendas_mall.each do |tienda|

        cobranza = CobranzaAlquiler.find_by('anio_alquiler = ? AND mes_alquiler = ? AND tienda_id = ?', year,mes, tienda.id)

        if !cobranza.blank?
          canon_fijo += cobranza.monto_canon_fijo
          canon_variable += cobranza.monto_canon_variable
          facturado = cobranza.monto_alquiler
          total_facturado += cobranza.monto_alquiler
          x_cobrar = cobranza.saldo_deudor
          total_x_cobrar += cobranza.saldo_deudor
          pagado = (facturado - x_cobrar)
          total_pagado += (facturado - x_cobrar)
          pagado_usd += pagado.to_f / CambioMoneda.last.cambio_ml_x_usd

        end
      end

      hash_stats[:num_mes] = mes
      hash_stats[:mes] = meses[mes-1]
      hash_stats[:canon_fijo] = ActionController::Base.helpers.number_to_currency(canon_fijo, separator: ',', delimiter: '.', format: "%n %u", unit: "")
      hash_stats[:canon_variable] = ActionController::Base.helpers.number_to_currency(canon_variable, separator: ',', delimiter: '.', format: "%n %u", unit: "")
      hash_stats[:facturado] = ActionController::Base.helpers.number_to_currency(total_facturado, separator: ',', delimiter: '.', format: "%n %u", unit: "")
      hash_stats[:x_cobrar] = ActionController::Base.helpers.number_to_currency(total_x_cobrar, separator: ',', delimiter: '.', format: "%n %u", unit: "")
      hash_stats[:pagado] = ActionController::Base.helpers.number_to_currency(total_pagado, separator: ',', delimiter: '.', format: "%n %u", unit: "")
      hash_stats[:pagado_usd] = ActionController::Base.helpers.number_to_currency(pagado_usd, separator: ',', delimiter: '.', format: "%n %u", unit: "")
      cobranzas << hash_stats
    end
    return cobranzas
  end



  def self.get_cobranzas_xmes(mall,year)
    ids_tiendas = mall.tiendas.pluck(:id)
    select("mes_alquiler,sum(monto_canon_fijo) as monto_canon_fijo,sum(monto_canon_variable) as monto_canon_variable,
          sum(monto_alquiler) as monto_alquiler,sum(monto_alquiler_usd) as monto_alquiler_usd,sum(saldo_deudor) as saldo_deudor")
          .where(tienda_id: ids_tiendas, anio_alquiler: year).group(:mes_alquiler).order(:mes_alquiler)
  end

  # Obtiene la gestión de cobranza que incluye: ventas, canon de alquiler, etc
  def self.get_getion_cobranzaBORRAR(mall,year,month)
    cobranza = Array.new
    total_canon_fijo = total_canon_variable = total_ventas = 0
    # Obtiene las ventas del mes x tienda
    venta_mes_xtienda = VentaMensual.get_ventas_mes_xtienda(mall,year,month)
    # Recorre las ventas del mes x tienda
    venta_mes_xtienda.each do |venta|
      # Obtiene el contrato de alquiler vigente de la tienda para mes-año dado
      contrato_alquiler = ContratoAlquiler.get_contrato_vigente_fecha(venta.tienda_id,year,month)
      # Obtiene la cobranza de alquiler de la tienda para el mes dado
      cobranza_alquiler = CobranzaAlquiler.get_cobranza_mes_tienda(venta.tienda_id,year,month)
      if cobranza_alquiler == nil
        tiene_cobranza = false
        montos_conon   = ContratoAlquiler.calculate_canon(contrato_alquiler,venta.monto_bruto,venta.monto_neto)
        canon_fijo     = montos_conon[:canon_fijo]
        canon_variable = montos_conon[:canon_variable]
      else
        tiene_cobranza = true
        canon_fijo     =  cobranza_alquiler.monto_canon_fijo
        canon_variable =  cobranza_alquiler.monto_canon_variable
      end
      total_canon_fijo     += canon_fijo
      total_canon_variable += canon_variable
      total_ventas         += venta.monto_bruto

      hash_cobranza = {tienda: venta.tienda_id,tipo_canon: contrato_alquiler.tipo_canon_alquiler.tipo,
                    editable: venta.editable,venta_mes: venta.monto,venta_neta: venta.monto_neto,
                    venta_bruta: venta.monto_bruto,canon_fijo: canon_fijo,canon_variable: canon_variable,
                    total_canon: canon_fijo + canon_variable,tiene_cobranza: tiene_cobranza,
                    total_ventas: total_ventas,suma_ventas_bruto_tiendas: venta.monto_bruto,
                    suma_venta_neta: venta.monto_neto,suma_canon_fijo: total_canon_fijo,suma_canon_variable: total_canon_variable,
                    suma_total_canon: venta.monto_neto + total_canon_variable,suma_total_ventas: total_ventas}

      cobranza << hash_cobranza
    end
    return cobranza
  end

  def self.get_gestion_cobranza(mall,year,month)
    cobranza = Array.new
    total_canon_fijo = total_canon_variable = total_canon = total_ventas = 0
    # Obtiene las ventas del mes x tienda
    venta_mes_xtienda = VentaMensual.get_ventas_mes_xtienda(mall,year,month)
    # Recorre las ventas del mes x tienda
    venta_mes_xtienda.each do |venta|
      # Obtiene el contrato de alquiler vigente de la tienda para mes-año dado
      contrato_alquiler = ContratoAlquiler.get_contrato_vigente_fecha(venta.tienda_id,year,month)
      # Obtiene la cobranza de alquiler de la tienda para el mes dado
      cobranza_alquiler = CobranzaAlquiler.get_cobranza_mes_tienda(venta.tienda_id,year,month)
      if cobranza_alquiler == nil
        tiene_cobranza = false
        canon_variable = contrato_alquiler.calcular_canon_variable_ml(venta.monto_bruto,venta.monto_neto)
        canon_fijo     = contrato_alquiler.canon_fijo_ml
      else
        tiene_cobranza = true
        canon_fijo     =  cobranza_alquiler.monto_canon_fijo
        canon_variable =  cobranza_alquiler.monto_canon_variable
      end
      total_canon_fijo     += canon_fijo
      total_canon_variable += canon_variable
      total_canon          += canon_fijo + canon_variable
      total_ventas         += venta.monto_bruto

      hash_cobranza = {tienda: venta.tienda_id,tipo_canon: contrato_alquiler.tipo_canon_alquiler.tipo,
                       editable: venta.editable,venta_mes: venta.monto_bruto,venta_neta: venta.monto_neto,
                       venta_bruta: venta.monto_bruto,canon_fijo: canon_fijo,canon_variable: canon_variable,
                       canon_alquiler: canon_fijo + canon_variable,tiene_cobranza: tiene_cobranza,
                       total_ventas: total_ventas,total_canon_fijo: total_canon_fijo,
                       total_canon_variable: total_canon_variable,total_canon: total_canon
                      }

      cobranza << hash_cobranza
    end
    return cobranza
  end
end
