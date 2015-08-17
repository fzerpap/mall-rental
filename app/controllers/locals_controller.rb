class LocalsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :check_user_mall

  before_action :set_local, only: [:show, :edit, :update, :destroy]
  helper_method :valid_locals

  # GET /locals
  # GET /locals.json
  def index
    @locals = Local.where(mall_id: current_user.mall.id).order(:nro_local)
    if @locals.blank?
      redirect_to controller: 'locals', action: 'new'
    end
  end

  # GET /locals/1
  # GET /locals/1.json
  def show

  end

  # GET /locals/new
  def new
    @local = Local.new
    @mall = current_user.mall
  end


  # GET /locals/1/edit
  def edit

  end

  # POST /locals
  # POST /locals.json
  def createBORRAR

    puts "Entro a create de local otra vez"
    puts params[:local][:nivel_mall_id]

    @local = Local.new(local_params)
    respond_to do |format|
      if !params[:local][:nivel_mall_id] == -1
        if @local.save
          puts "entró a salvar el local"
          format.html { redirect_to local_index_path, notice: 'Local fue creado satisfactoriamente.' }
          format.json { render :index, status: :created, location: @local }
        else
          puts "no entró a salvar el local"

          @local.errors.add(:name,"Debe guardarse cuando se ingresa uno nuevo")
          format.html { render :new }
          format.json { render json: @local.errors, status: :unprocessable_entity }
        end
      else
        puts "el nivel mall = -1"

        format.html { render :new, message: "La Ubicación - Nivel ingresada no fue salvada"}
        format.json { render json: @local.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @local = Local.new(local_params)
    respond_to do |format|
      if @local.save
        format.html { redirect_to local_index_path, notice: 'Local fue creado satisfactoriamente.' }
        format.json { render :index, status: :created, location: @local }
      else
        format.html { render :new }
        format.json { render json: @local.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locals/1
  # PATCH/PUT /locals/1.json
  def update
    respond_to do |format|
      if @local.update(local_params)
        format.html { redirect_to local_index_path, notice: 'Local fue actualizado satisfactoriamente.' }
        format.json { render :index, status: :ok, location: @local }
      else
        format.html { render :edit }
        format.json { render json: @local.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locals/1
  # DELETE /locals/1.json
  def destroy
    respond_to do |format|
      if @local.destroy
        format.html { redirect_to local_index_path, notice: 'Local eliminado exitosamente' }
        format.json { head :no_content }
      else
        format.html { redirect_to local_index_path, alert: 'El local no pueder ser eliminado porque tiene tiendas asociadas' }
        format.json { head :no_content }
      end
    end
  end

  def valid_locals
    @locals = Local.where(mall_id: current_user.mall.id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_local
      @local = Local.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def local_params
      params.require(:local).permit(:foto, :nro_local, :ubicacion_pasillo, :area_planta, :area_terraza, :area_mezanina, :tipo_local_id, :tipo_estado_local, :nivel_mall_id, :mall_id)
    end


end
