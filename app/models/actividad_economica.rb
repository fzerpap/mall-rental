# == Schema Information
#
# Table name: actividad_economicas
#
#  id         :integer          not null, primary key
#  nombre     :string(255)
#  mall_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class ActividadEconomica < ActiveRecord::Base
  belongs_to :mall
  has_many :tiendas

  validates :nombre, :mall_id, presence: true
  validates_uniqueness_of :nombre, scope: :mall_id, message: 'ya está en uso'

  before_destroy :confirm_presence_of_tiendas

  def confirm_presence_of_tiendas
    if tiendas.any?
      return false
    end
  end

  def self.valid_actividad_economicas(user)
    where(mall_id: user.mall_id)
  end

end
