class NivelMallsController < ApplicationController
  before_action :set_nivel_mall, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :check_user_mall

  # GET /nivel_malls
  # GET /nivel_malls.json
  def index
    #@mall = Mall.find(params[:mall_id])
    @nivel_malls = NivelMall.where(mall_id: current_user.mall.id).order(:nombre)
  end

  # GET /nivel_malls/1
  # GET /nivel_malls/1.json
  def show
  end

  # GET /nivel_malls/new
  def new
    @mall = current_user.mall
    @nivel_mall = NivelMall.new
  end

  # GET /nivel_malls/1/edit
  def edit
  end

  # POST /nivel_malls
  # POST /nivel_malls.json
  def create
    @nivel_mall = NivelMall.new(nivel_mall_params)

    respond_to do |format|
      if @nivel_mall.save
        format.html { redirect_to nivel_malls_path: 'Nivel mall fue creado exitosamente.' }
        format.json { render :index, status: :created, location: @nivel_mall }
      else
        format.html { render :new }
        format.json { render json: @nivel_mall.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nivel_malls/1
  # PATCH/PUT /nivel_malls/1.json
  def update
    puts "Entró a update Nivel Mall"
    respond_to do |format|
      if @nivel_mall.update(nivel_mall_params)
        format.html { redirect_to nivel_malls_path, notice: 'Nivel mall fue actualizado exitosamente.' }
        format.json { render :index, status: :ok, location: @nivel_mall }
      else
        format.html { render :edit }
        format.json { render json: @nivel_mall.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nivel_malls/1
  # DELETE /nivel_malls/1.json
  def destroy
    respond_to do |format|
      if @nivel_mall.destroy
        format.html { redirect_to nivel_malls_path, notice: "El nivel #{@nivel_mall.nombre} eliminado satisfactoriamente"  }
        format.json { head :no_content }
      else
        format.html { redirect_to nivel_malls_path, alert: "El nivel #{@nivel_mall.nombre} no puede ser eliminado porque tiene locales asociados"  }
        format.json { head :no_content }
      end
    end
  end


  def test_ajax
    render :layout => nil
    respond_to do |format|
      format.json { render :index, status: :ok, location: 1 }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nivel_mall
      @nivel_mall = NivelMall.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def nivel_mall_params
      params.require(:nivel_mall).permit(:nombre, :mall_id)
    end
end
