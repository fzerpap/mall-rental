class CuentaBancariaController < ApplicationController
  before_action :set_cuenta_bancarium, only: [:show, :edit, :update, :destroy]
  before_action :check_user_mall


  def index
    @cuenta_bancarias = current_user.mall.cuenta_bancaria
  end

  def show

  end

  def new
    @cuenta_bancarium = CuentaBancarium.new

  end

  def edit
    @mall = current_user.mall
  end

  def create
    @cuenta_bancarium = CuentaBancarium.new(cuenta_bancarium_params)
    respond_to do |format|
      if @cuenta_bancarium.save
        format.html { redirect_to cuenta_bancaria_path, notice: 'Cuenta Bancaria guardada exitosamente.' }
        format.json { render :index, status: :created, location: @cuenta_bancarium }
      else
        format.html {render :new }
        format.json { render json: @cuenta_bancarium.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    respond_to do |format|
      if @cuenta_bancarium.update(cuenta_bancarium_params)
        format.html { redirect_to cuenta_bancaria_path, notice: 'Cuenta Bancaria guardada exitosamente.' }
        format.json { render :index, status: :ok, location: @cuenta_bancarium }
      else
        format.html { render :edit }
        format.json { render json: @cuenta_bancarium.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @cuenta_bancarium.destroy
        format.html { redirect_to cuenta_bancarium_index_path, notice: 'Cuenta Bancaria eliminada exitosamente' }
        format.json { head :no_content }
      else
        format.html { redirect_to cuenta_bancarium_index_path, alert: 'La Cuenta Bancaria no pueder ser eliminada porque tiene depósitos asociadas' }
        format.json { head :no_content }
      end
    end
  end

  private
    def set_cuenta_bancarium
      @cuenta_bancarium = CuentaBancarium.find(params[:id])
    end

    def cuenta_bancarium_params
      params.require(:cuenta_bancarium).permit(:nro_cta, :tipo_cuenta, :beneficiario, :doc_identidad, :banco_id)
    end
end
