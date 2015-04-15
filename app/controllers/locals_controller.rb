class LocalsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_local, only: [:show, :edit, :update, :destroy]

  # GET /locals
  # GET /locals.json
  def index
    #raise params.inspect
    @mall = Mall.find(params[:mall_id])
    @locals = Local.where(mall_id: params[:mall_id])
    @local1 = Local.new
    @local2 = Local.new
  end

  # GET /locals/1
  # GET /locals/1.json
  def show

  end

  # GET /locals/new
  def new
    @local = Local.new
    @mall = Mall.find(params[:mall_id])
  end


  # GET /locals/1/edit
  def edit

  end

  # POST /locals
  # POST /locals.json
  def create
    @local = Local.new(local_params)
    respond_to do |format|
      if @local.save
       # format.html { redirect_to locals_path(mall_id: local_params[:mall_id]), notice: 'Local fue creado satisfactoriamente.' }
        format.html { redirect_to local_index_path(local_params[:mall_id]), notice: 'Local fue creado satisfactoriamente.' }
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
        format.html { redirect_to local_index_path(@local.mall_id), notice: 'Local fue actualizado satisfactoriamente.' }
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
    @mall_id = @local.mall_id
    @local.destroy
    respond_to do |format|
      format.html { redirect_to local_index_path(@mall_id), notice: 'Local eliminado exitosamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_local
      @local = Local.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def local_params
      params.require(:local).permit(:foto, :nro_local, :ubicacion_pasillo, :area, :propiedad_mall, :tipo_local_id, :nivel_mall_id, :mall_id)
    end
end
