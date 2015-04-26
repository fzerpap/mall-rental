class VentasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_venta, only: [:show, :edit, :update, :destroy]
  #load_and_authorize_resource

  def index
    @tienda_id = params[:tienda_id]
    if @tienda_id.nil?
      @tienda_id = current_user.tienda
      @ventas_mall = false
    else
      @ventas_mall = true
    end

    @tienda = Tienda.find(@tienda_id)
    @local = Local.find(@tienda.local_id)
    @ventas = Venta.where(tienda_id: @tienda.id)
    @contrato_alquiler = ContratoAlquiler.where(tienda: @tienda)
  end

  def cobranza
    @tienda = current_user.tienda
    @ventas = Venta.where(tienda_id: @tienda.id)
    @contrato_alquiler = ContratoAlquiler.where(tienda: @tienda)
  end

  def mall_tiendas

    @tienda = current_user.tienda

    @ventas = Venta.where(tienda_id: @tienda_id)
    @contrato_alquiler = ContratoAlquiler.where(tienda: @tienda)
  end

  def  mensuales
    @mall = current_user.mall
    #@tiendas = current_user.mall.tiendas
    @ventas = Venta.all
  end


=begin
  def mes

    @tienda = current_user.mall.tiendas.first

    @ventas = Venta.where(tienda_id: @tienda_id)
    @contrato_alquiler = ContratoAlquiler.where(tienda: @tienda)
  end
=end

  def show
  end

  def new
    @venta = Venta.new
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
  def set_venta
    @venta = current_user.tienda.ventas.find_by(id: params[:id])
  end

  def venta_params
    params.require(:venta).permit(:fecha, :monto_ml, :monto_usd, :tienda)
  end
end
