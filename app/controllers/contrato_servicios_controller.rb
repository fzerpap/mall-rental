class ContratoServiciosController < ApplicationController
  before_action :set_contrato_servicio, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @contrato_servicios = ContratoServicio.all
    respond_with(@contrato_servicios)
  end

  def show
    respond_with(@contrato_servicio)
  end

  def new
    @contrato_servicio = ContratoServicio.new
    respond_with(@contrato_servicio)
  end

  def edit
  end

  def create
    @contrato_servicio = ContratoServicio.new(contrato_servicio_params)
    @contrato_servicio.save
    respond_with(@contrato_servicio)
  end

  def update
    @contrato_servicio.update(contrato_servicio_params)
    respond_with(@contrato_servicio)
  end

  def destroy
    @contrato_servicio.destroy
    respond_with(@contrato_servicio)
  end

  private
    def set_contrato_servicio
      @contrato_servicio = ContratoServicio.find(params[:id])
    end

    def contrato_servicio_params
      params.require(:contrato_servicio).permit(:nro_contrato, :fecha_inicio, :fecha_fin, :archivo_contrato, :monto_ml, :moonto_usd, :porcIngresosAlquiler, :estado_contrato, :locatarios, :contrato_ml)
    end
end
