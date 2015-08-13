class EstadisticasController < ApplicationController
  before_action :authenticate_user!
  #authorize_resource class: :estadisticas
  before_action :check_user_mall

  def mf_intermensuales_vxa
    @criterio = params[:criterio]

  end

  def filtro_intermensuales
    @estadisticas = Tienda.estadisticas(current_user.mall, params[:fecha_init], params[:fecha_end], params[:nivel_mall_id], params[:actividad_economica_id], params[:tipo_local_id], params[:criterio])
    render partial: 'table_intermensuales_vxa'
  end

  def mf_mensuales_vxa
    @estadisticas = Tienda.estadisticas_mensuales(current_user.mall, current_user.mall.contrato_alquilers.first.fecha_inicio.year)
  end

  def filtro_mensuales
    @estadisticas = Tienda.estadisticas_mensuales(current_user.mall, params[:year])
    render partial: 'table_mensuales_vxa'
  end


  private
    def self.permission
      'estadisticas'
    end
end
