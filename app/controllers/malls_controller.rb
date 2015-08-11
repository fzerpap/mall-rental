class MallsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_mall, only: [:show, :edit, :update, :destroy]

  # GET /malls
  # GET /malls.json
  def index
    @malls = Mall.all
  end

  # GET /malls/1
  # GET /malls/1.json
  def show
  end

  # GET /malls/new
  def new
    @mall = Mall.new
  end

  # GET /malls/1/edit
  def edit
  end

  # POST /malls
  # POST /malls.json
  def create
    @mall = Mall.new(mall_params)
    respond_to do |format|
      if @mall.save
        format.html { redirect_to malls_path, notice: 'Mall fue creado exitosammente.' }
        format.json { render :index, status: :created, location: @mall }
      else
        format.html { render :new }
        format.json { render json: @mall.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /malls/1
  # PATCH/PUT /malls/1.json
  def update
    respond_to do |format|
      if @mall.update(mall_params)
        format.html { redirect_to malls_path, notice: 'Mall actualizado correctamente.' }
        format.json { render :index, status: :ok, location: @mall }
      else
        format.html { render :edit }
        format.json { render json: @mall.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /malls/1
  # DELETE /malls/1.json
  def destroy
    respond_to do |format|
      if @mall.destroy
        format.html { redirect_to malls_path, notice: "Mall #{@mall.nombre} eliminado satisfactoriamente"  }
        format.json { head :no_content }
      else
        format.html { redirect_to malls_path, alert: "El mall #{@mall.nombre} no puede ser eliminado, porque tiene usuarios asociados"  }
        format.json { head :no_content }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mall
      @mall = Mall.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mall_params
      params.require(:mall).permit(:nombre, :abreviado, :rif, :direccion_fiscal, :telefono, :pai_id)
    end
end
