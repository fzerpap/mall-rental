class PrecioServicio < ActiveRecord::Base
  belongs_to :tipo_servicio
  belongs_to :tipo_contrato_servicio
  has_many :contrato_servicios
end
