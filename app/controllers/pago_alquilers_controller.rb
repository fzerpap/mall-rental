class PagoAlquilersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_pago_alquiler, only: [:show, :edit, :update, :destroy]
  before_action :check_user_mall

  # GET /pago_alquilers
  # GET /pago_alquilers.json
  def indexBORRAR

    if params[:year].nil?
      today = Time.now
      month = today.strftime("%-m").to_i
      year = today.strftime("%Y")
    else
      month = params[:month]
      year = params[:year]
    end

    @cobranza_alquilers = CobranzaAlquiler.get_cobranza_mes_xtienda(current_user.mall,year,month)
    @total_cobranza     = CobranzaAlquiler.get_total_cobranza_mes(current_user.mall,year,month)

    #@suma_monto_x_cobrar = CobranzaAlquiler.saldo_deudor_x_mes(current_user.mall,year,month)
    #@suma_monto_alquiler = CobranzaAlquiler.monto_alquiler_x_mes(current_user.mall,year,month)
    #@suma_monto_pagado = @suma_monto_alquiler - @suma_monto_x_cobrar

    if @suma_monto_pagado > 0
      @month = month.to_i
    elsif
      if params[:month].nil?
        month -= 1
        @month = month.to_i
        @cobranza_alquilers = CobranzaAlquiler.get_cobranza_mes_xtienda(current_user.mall,year,month)
        @suma_monto_x_cobrar = CobranzaAlquiler.saldo_deudor_x_mes(current_user.mall,year,month)
        @suma_monto_alquiler = CobranzaAlquiler.monto_alquiler_x_mes(current_user.mall,year,month)
        @suma_monto_pagado = @suma_monto_alquiler - @suma_monto_x_cobrar
      else
        @month = params[:month].to_i
      end
    end
  end

  def index
    if params[:year].nil?
      today = Time.now
      month = today.strftime("%-m").to_i
      year = today.strftime("%Y")
      if month > 1
        month = month - 1
      else
        month = 12
        year = year - 1
      end
    else
      month = params[:month]
      year = params[:year]
    end
    @cobranza_alquilers  = CobranzaAlquiler.get_cobranza_mes_xtienda(current_user.mall,year,month)
    @total_cobranza     = CobranzaAlquiler.get_total_cobranza_mes(current_user.mall,year,month)
    @month = month.to_i
  end

  # GET /pago_alquilers/1
  # GET /pago_alquilers/1.json
  def show
  end

  # GET /pago_alquilers/new
  def mf_new_transferencia
    tienda = current_user.tienda
    if tienda.blank?
      authorize! :index, root_url, :message => "Debe tener una tienda asignada."
    end
    
    @facturas_x_pagar = CobranzaAlquiler.get_facturas_x_pagar(tienda.id)
    @total_facturado = FacturaAlquiler.get_total_facturado(tienda.id)
    @total_x_pagar = CobranzaAlquiler.saldo_deudor_x_tienda(tienda.id)
    @pago_alquiler = PagoAlquiler.new
    @detalle_pago_alquiler = @pago_alquiler.detalle_pago_alquilers.build
  end

  def mf_new_cheque_efectivo
    @pago_alquiler = PagoAlquiler.new
  end

  # GET /pago_alquilers/1/edit
  def edit
  end

  # POST /pago_alquilers
  # POST /pago_alquilers.json
  def create

    @pago_alquiler = PagoAlquiler.new(pago_alquiler_params)
    respond_to do |format|
      if @pago_alquiler.save
        cant_fact = params[:pago_alquiler][:detalle_pago_alquilers_attributes].length
        for i in (0..cant_fact-1)
          num = i.to_s
          monto = params[:pago_alquiler][:detalle_pago_alquilers_attributes][num]['monto_fact']
          factura_id = params[:pago_alquiler][:detalle_pago_alquilers_attributes][num]['factura_alquiler_id']
          cobranza_id = params[:pago_alquiler][:detalle_pago_alquilers_attributes][num]['cobranza_alquiler_id']

          pago_id = @pago_alquiler.id
          detalle =  DetallePagoAlquiler.new(monto: monto, pago_alquiler_id: pago_id, factura_alquiler_id: factura_id)
          cobranza_alquiler = CobranzaAlquiler.find(cobranza_id)

          factura = FacturaAlquiler.find(factura_id)
          monto_abonado = factura.monto_abono.to_f
          monto_abono = monto_abonado + monto.to_f
          monto_factura = factura.monto_factura
          saldo_deudor = monto_factura - monto_abono
          obj = {
              :monto_abono => monto_abono,
              :saldo_deudor => saldo_deudor,
          }
          fact_alquiler = obj

          if detalle.save
            factura.update(fact_alquiler)
            cobranza_alquiler.update(saldo_deudor: saldo_deudor)
            format.html { redirect_to pago_alquilers_path, notice: 'Pago Alquiler guardado existosamente.' }
            format.json { render :index, status: :created, location: @pago_alquiler }
          else
            format.html { render :new }
            format.json { render json: @pago_alquiler.errors, status: :unprocessable_entity }
          end
        end
      else
        format.html { render :new }
        format.json { render json: @pago_alquiler.errors, status: :unprocessable_entity }
      end
    end
  end

  def mf_facturas_tiendas

    @tienda_id = params[:tienda_id]
    @pago_alquiler = PagoAlquiler.new
    @detalle_pago_alquiler = @pago_alquiler.detalle_pago_alquilers.build

    @facturas_x_pagar = CobranzaAlquiler.get_facturas_x_pagar(@tienda_id)
    @total_x_pagar = CobranzaAlquiler.saldo_deudor_x_tienda(@tienda_id)
    @total_facturado = FacturaAlquiler.get_total_facturado(@tienda_id)

  end

  def mf_pagos_mensuales
    year = Time.now.strftime("%Y")
    mall = current_user.mall

    @cobranzas = CobranzaAlquiler.get_cobranzas_xmes(mall,year)
    @totales = CobranzaAlquiler.get_total_cobranzas_anio(mall,year)

    @meses = ["","Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]
    @pagos_mensuales = true

  end

  def pagos
    year = params[:year]
    mall = current_user.mall

    @cobranzas = CobranzaAlquiler.get_cobranza_xmes(mall,year)
    @totales = CobranzaAlquiler.get_total_cobranzas_xmes(mall,year)

    render partial: 'pagos_mensuales'
  end

  # PATCH/PUT /pago_alquilers/1
  # PATCH/PUT /pago_alquilers/1.json
  def update
    respond_to do |format|
      if @pago_alquiler.update(pago_alquiler_params)
        format.html { redirect_to pago_alquilers_url, notice: 'Pago alquiler se guardo fino.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @pago_alquiler.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /pago_alquilers/1
  # DELETE /pago_alquilers/1.json
  def destroy
    @pago_alquiler.destroy
    respond_to do |format|
      format.html { redirect_to pago_alquilers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pago_alquiler
      @pago_alquiler = PagoAlquiler.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pago_alquiler_params
      params.require(:pago_alquiler).permit(:nro_recibo, :fecha, :monto, :monto_usd, :nro_cheque_confirmacion, :banco_emisor, :tipo_pago, :cuenta_bancarium_id, detalle_pago_alquilers_params: [:factura_alquiler_id, :monto, :pago_alquiler_id] )
    end
end
