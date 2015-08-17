# == Schema Information
#
# Table name: locals
#
#  id                :integer          not null, primary key
#  foto              :string(255)
#  nro_local         :string(255)
#  ubicacion_pasillo :string(255)
#  tipo_local_id     :integer
#  nivel_mall_id     :integer
#  mall_id           :integer
#  created_at        :datetime
#  updated_at        :datetime
#  area_planta       :decimal(, )      default(0.0)
#  area_terraza      :decimal(, )      default(0.0)
#  area_mezanina     :decimal(, )      default(0.0)
#  tipo_estado_local :integer
#


class Local < ActiveRecord::Base

  belongs_to :mall
  belongs_to :nivel_mall
  belongs_to :tipo_local
  has_many  :tiendas

  before_destroy :confirm_presence_of_tiendas

  validates :tipo_local_id, :nro_local, :area_planta, :area_terraza, :area_mezanina, presence: true
  validates :area_planta, :area_terraza, :area_mezanina, numericality: true
  validates :tipo_estado_local, presence: true

  validates :nivel_mall_id, numericality: { greater_than_or_equal_to: 1 }
  validates_uniqueness_of :nro_local, scope: :mall_id, message: 'ya está en uso'

   mount_uploader :foto, AvatarUploader

  enum tipo_estado_local: [:Disponible, :Alquilado, :En_Reparacion, :Vendido]

  private
  def confirm_presence_of_tiendas
    if tiendas.any?
      return false
    end
  end

  def self.valid_locals(user)
    return Local.joins(:mall).where(malls: {id: user.mall_id}).order(:nro_local)
  end

  def self.valid_tipo_estado_local
    %w[Disponible Alquilado En_Reparacion Vendido]
  end
end
