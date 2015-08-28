class EstadisticasController < ApplicationController
  before_action :authenticate_user!
  #authorize_resource class: :estadisticas
  before_action :check_user_mall

  def mf_intermensuales_vxa
    @criterio = params[:criterio]

  end

  def filtro_intermensuales
    # Obtiene las estadísticas
    @estadisticas = Tienda.estadisticas(current_user.mall, params[:fecha_init], params[:fecha_end], params[:nivel_mall_id], params[:actividad_economica_id], params[:tipo_local_id], params[:criterio])

    # Obtiene los totales de las estadísticas
    keys = [:venta_diaria, :canon_fijo_ml, :porc_canon, :total]
    @totales = @estadisticas.map { |h| h.values_at(*keys) }.inject { |a, v| a.zip(v).map(&:sum) }
    @totales << @totales[3] / CambioMoneda.last.cambio_ml_x_usd

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
