class TiendasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tienda, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :check_user_mall

  def index
    @tiendas = current_user.mall.tiendas
  end

  def show
  end

  def new
    @tienda = Tienda.new
    @contrato_alquiler = @tienda.contrato_alquilers.build
  end

  def edit
    @contrato_alquiler = @tienda.contrato_alquilers.last
  end

  def create
    @tienda = Tienda.new(tienda_params)
    respond_to do |format|
      if @tienda.save
        format.html { redirect_to tiendas_path, notice: 'Tienda creada satisfactoriamente.' }
        format.json { render action: 'show', status: :created, location: @tienda }
      else
        format.html { render action: 'new' }
        format.json { render json: @tienda.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @tienda.update(tienda_params)
        format.html { redirect_to tiendas_path, notice: 'Tienda actualizada satisfactoriamente.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tienda.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @tienda.destroy
        format.html { redirect_to tiendas_path, notice: 'Tienda eliminada satisfactoriamente'  }
        format.json { head :no_content }
      else
        format.html { redirect_to tiendas_path, alert: 'La tienda no puede ser eliminada, porque tiene contratos de alquiler asociados'  }
        format.json { head :no_content }
      end
    end
  end

  def mf_dynamic_filter
    @tiendas = current_user.mall.tiendas.joins(:contrato_alquilers, :actividad_economica, :nivel_mall).by_nivel_mall(params[:nivel_mall_id]).by_actividad_economica(params[:actividad_economica_id]).by_vencimiento(params[:vencido])
    if @tiendas.blank?
      render partial: 'tiendas_filter_nil'
    else
      render partial: 'table_tiendas_filter'
    end
  end


  private
    def set_tienda
      @tienda = current_user.mall.tiendas.find_by(id: params_id)
    end

    def tienda_params

      params.require(:tienda).permit(:nombre, :local_id, :arrendatario_id, :actividad_economica_id, :monto_garantia, :codigo_contable, contrato_alquilers_attributes: [ :id, :tipo_canon_alquiler_id, :fecha_inicio, :fecha_fin, :archivo_contrato, :canon_fijo_ml, :porc_canon_ventas ,:requerida_venta])
    end
end
