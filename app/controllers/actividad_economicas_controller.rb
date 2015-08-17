class ActividadEconomicasController < ApplicationController
  before_action :set_actividad_economica, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :check_user_mall

  # GET /actividad_economicas
  # GET /actividad_economicas.json
  def index

    @actividad_economicas = ActividadEconomica.where(mall_id: current_user.mall.id).order(:nombre)

  end


  # GET /actividad_economicas/1
  # GET /actividad_economicas/1.json
  def show
  end

  # GET /actividad_economicas/new
  def new
    @actividad_economica = ActividadEconomica.new
  end

  # GET /actividad_economicas/1/edit
  def edit
  end

  # POST /actividad_economicas
  # POST /actividad_economicas.json
  def create
    @actividad_economica = ActividadEconomica.new(actividad_economica_params)

    respond_to do |format|
      if @actividad_economica.save
        format.html { redirect_to actividad_economicas_path, notice: 'Actividad economica fue creada exitosamente.' }
        format.json { render :index, status: :created, location: @actividad_economica }
      else
        format.html { render :new }
        format.json { render json: @actividad_economica.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /actividad_economicas/1
  # PATCH/PUT /actividad_economicas/1.json
  def update
    respond_to do |format|
      if @actividad_economica.update(actividad_economica_params)
        format.html { redirect_to actividad_economicas_path, notice: 'Actividad económica fue actualizada exitosamente.' }
        format.json { render :index, status: :ok, location: @actividad_economica }
      else
        format.html { render :edit }
        format.json { render json: @actividad_economica.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /actividad_economicas/1
  # DELETE /actividad_economicas/1.json
  def destroy
    respond_to do |format|
      if @actividad_economica.destroy
        format.html { redirect_to actividad_economicas_path, notice: "Activdiad #{@actividad_economica.nombre} eliminada satisfactoriamente"  }
        format.json { head :no_content }
      else
        format.html { redirect_to actividad_economicas_path, alert: "La actividad #{@actividad_economica.nombre} no puede ser eliminada, porque tiene tiendas asociadas"  }
        format.json { head :no_content }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_actividad_economica
      @actividad_economica = ActividadEconomica.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def actividad_economica_params
      params.require(:actividad_economica).permit(:nombre, :mall_id)
    end
end
