class CuentaBancariaController < ApplicationController
  before_action :set_cuenta_bancarium, only: [:show, :edit, :update, :destroy]
  before_action :check_user_mall
  respond_to :html

  def index
    @cuenta_bancarias = CuentaBancarium.all

  end

  def show

  end

  def new
    @cuenta_bancarium = CuentaBancarium.new
    @mall = current_user.mall

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
        format.html { render :new }
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
    @cuenta_bancarium.destroy
    respond_to do |format|
      format.html { redirect_to cuenta_bancarium_url, notice: 'Cuenta Bancaria se ha eliminado exitosamente.' }
      format.json { head :no_content }
    end

  end

  private
    def set_cuenta_bancarium
      @cuenta_bancarium = CuentaBancarium.find(params[:id])
    end

    def cuenta_bancarium_params
      params.require(:cuenta_bancarium).permit(:nro_cta, :tipo_cuenta, :beneficiario, :doc_identidad, :banco_id, :mall_id)
    end
end
