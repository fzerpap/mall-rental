class BancosController < ApplicationController
  before_action :set_banco, only: [:show, :edit, :update, :destroy]

  respond_to :html

  banco = ""
  def index
    mall = current_user.mall
    @bancos = mall.bancos
  end

  def show

  end

  def new
    @banco = Banco.new
    @mall = current_user.mall
  end

  def edit
    banco = params[:nombre]
  end

  def create
    @banco = Banco.new(banco_params)
    respond_to do |format|
       if @banco.save
        format.html { redirect_to bancos_path, notice: 'Banco fue guardado satisfactoriamente.' }
        format.json { render :index, status: :created, location: @banco }
      else
        format.html { render :new }
        format.json { render json: @cliente.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    respond_to do |format|
      if @banco.update(banco_params)
        format.html { redirect_to bancos_path, notice: 'Banco fue actualizado satisfactoriamente.' }
        format.json { render :index, status: :ok, location: @banco }
      else
        format.html { render :new }
        format.json { render json: @banco.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @banco.destroy
        format.html { redirect_to banco_index_path, notice: 'Banco eliminado exitosamente' }
        format.json { head :no_content }
      else
        format.html { redirect_to banco_index_path, alert: 'El banco no pueder ser eliminado porque tiene cuentas asociadas' }
        format.json { head :no_content }
      end
    end
  end


  private
    def set_banco
      @banco = Banco.find(params[:id])
    end

    def banco_params
      params.require(:banco).permit(:nombre,:mall_id)
    end

end
