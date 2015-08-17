class TipoContratoServicio < ActiveRecord::Base

  has_many :precio_servicios
  has_many :contrato_servicios

  def tipo_contrato
    self.tipo.humanize.titleize
  end
end
