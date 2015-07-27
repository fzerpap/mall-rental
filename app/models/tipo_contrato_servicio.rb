class TipoContratoServicio < ActiveRecord::Base

  validates :tipo, inclusion: { in: ['servicio_x_locatario','venta_del_software', 'servicios_x_porc_ingresos_alquiler']}
  has_many :precio_servicios
  has_many :contrato_servicios

  def tipo_contrato
    self.tipo.humanize.titleize
  end
end
