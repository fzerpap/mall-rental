class ContratoServiciosController < ApplicationController
  before_action :set_contrato_servicio, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @contrato_servicios = ContratoServicio.all

    if @contrato_servicios.blank?
      redirect_to controller: 'contrato_servicios', action: 'new'
    end
  end

  def show
    @contrato = ContratoServicio.find(params['id'])
  end

  def new
    @contrato_servicio = ContratoServicio.new
  end

  def edit
  end

  def create

    @contrato_servicio = ContratoServicio.new(contrato_servicio_params)
    respond_to do |format|
      if @contrato_servicio.save
        cliente = Cliente.find(contrato_servicio_params['cliente_id'])
        cliente.update(tipo_servicio_id: contrato_servicio_params['tipo_servicio_id'])
        format.html { redirect_to contrato_servicios_path, notice: 'Contrato de Servicio guardado exitosamente.' }
        format.json { render :index, status: :created, location: @contrato_servicio }
      else
        format.html { render :new }
        format.json { render json: @contrato_servicio.errors, status: :unprocessable_entity }
      end
    end

  end

  def update

    respond_to do |format|
      if @contrato_servicio.update(contrato_servicio_params)
        cliente = Cliente.find(contrato_servicio_params['cliente_id'])

        cliente.update(tipo_servicio_id: params['tipo_servicio_id']['tipo_servicio_id'])

        format.html { redirect_to contrato_servicios_path, notice: 'Contrato de Servicio modificado exitosamente.' }
        format.json { render :index, status: :ok, location: @contrato_servicio }
      else
        format.html { render :edit }
        format.json { render json: @contrato_servicio.errors, status: :unprocessable_entity }
      end
    end

  end

  def destroy
    @contrato_servicio.destroy
    respond_to do |format|
      format.html { redirect_to contrato_servicios_url, alert: 'Se ha eliminado el Contrato de Servicio'  }
      format.json { head :no_content }
    end

  end

  private
    def set_contrato_servicio
      @contrato_servicio = ContratoServicio.find(params[:id])
    end

    def contrato_servicio_params
      params.require(:contrato_servicio).permit(:nro_contrato, :fecha_inicio, :fecha_fin, :archivo_contrato, :monto_ml, :monto_usd, :porc_ingresos_alquiler, :estado_contrato, :locatarios, :contrato_ml, :tipo_contrato_servicio_id, :precio_servicio_id, :cliente_id)
    end
end
