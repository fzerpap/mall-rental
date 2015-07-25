class ContratoServicio < ActiveRecord::Base
  belongs_to :cliente
  belongs_to :precio_servicio
end
