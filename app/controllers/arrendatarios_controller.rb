class ArrendatariosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_arrendatario, only: [:edit, :show, :update, :destroy]
  load_and_authorize_resource
  before_action :check_user_mall

  respond_to :html


  def index
    @arrendatarios = current_user.mall.arrendatarios.order(:nombre)
    if @arrendatarios.blank?
      redirect_to new_arrendatario_path
    end
  end

  def new
    @arrendatario = Arrendatario.new
    @locals = Local.where(mall_id: current_user.mall.id)
  end

  def create
    @arrendatario = Arrendatario.new arrendatario_params.merge(mall_id: current_user.mall_id)
    respond_to do |format|
      if @arrendatario.save
        format.html { redirect_to arrendatarios_path, notice: 'Arrendatario creado existosamente.' }
        format.json { render :index, status: :created, location: @arrendatario }
      else
        format.html { render :new }
        format.json { render json: @arrendatario.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @arrendatario.update(arrendatario_params)
        format.html { redirect_to arrendatarios_path, notice: 'Arrendatario actualizado exitosamente.' }
        format.json { render :index, status: :created, location: @arrendatario }
      else
        format.html { render :edit }
        format.json { render json: @arrendatario.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @arrendatario.destroy
        format.html { redirect_to arrendatarios_path, notice: 'Arrendatario eliminado exitosamente' }
        format.json { head :no_content }
      else
        format.html { redirect_to arrendatarios_path, alert: 'El arrendatario no pueder ser eliminado porque tiene tiendas asociadas' }
        format.json { head :no_content }
      end
    end
  end


  def show
  end

  private
    def set_arrendatario
      @arrendatario = current_user.mall.arrendatarios.find_by(id: params[:id])
    end

    def arrendatario_params
      params.require(:arrendatario).permit(:nombre, :rif, :direccion, :telefono, :nombre_rl, :cedula_rl, :email_rl, :telefono_rl, :registro_mercantil)
    end
end