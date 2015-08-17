class Cliente < ActiveRecord::Base
  belongs_to :mall
  belongs_to :tipo_servicio
  has_many :contrato_servicios

  validates :tipo_servicio_id, :mall_id, presence: true
  validates_uniqueness_of :nombre, scope: :mall_id, message: 'ya está en uso'


  def self.valid_clientes(user)
    return Cliente.where(mall_id: user.mall_id)
  end
end
