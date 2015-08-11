class VentaDiariaController < ApplicationController
  before_action :set_venta_diarium, only: [:show, :edit, :update, :destroy]

  def index
    # @user_tienda = current_user.tienda
    # if @user_tienda.blank?
    #   authorize! :index, root_url, :message => "Debe tener una tienda asignada."
    # end

    @today = Time.now
    @year = @today.strftime("%Y")
    tienda_id = params[:tienda_id]

    if !(params[:month].nil?)
      @month = params[:month]
    else
      @month = @today.strftime("%m")
    end

    if tienda_id.nil?
      tienda_id = current_user.tienda
      @ventas_mall = false
    else
      @ventas_mall = true
    end

    @tienda = Tienda.find(tienda_id)

    @contrato_alquiler = ContratoAlquiler.where(tienda_id: @tienda.id).last
    tipo_canon_id = @contrato_alquiler.tipo_canon_alquiler_id

    [1,2,4].include?(tipo_canon_id) ? @render = 'venta_bruta' : @render = 'venta_neta'

  end

  def mf_cobranza

  end

  def mf_mall_tiendas
    if !params[:acceso].nil?
      @acceso = params[:acceso]
      @month = params[:month]
      @today = Time.now
      @year == @today.strftime("%Y")
      @month = Date.new(@year.to_i,@month.to_i,1)
    else
      @acceso = 1
    end
  end

  def mf_mensuales
    @mall = current_user.mall
  end


  def show

  end

  def new

  end

  def edit
  end

  def create

  end

  def update

  end

  def destroy

  end

  private
    def set_venta_diarium
      @venta_diarium = current_user.tienda.venta_diarium.find_by(id: params[:id])

    end

    def venta_diarium_params
      params.require(:venta_diarium).permit(:fecha, :monto, :monto_notas_credito, :monto_bruto, :monto_bruto_usd, :monto_costo_venta, :monto_neto, :monto_neto_usd, :editable)
    end
end
