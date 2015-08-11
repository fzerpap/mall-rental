# == Schema Information
#
# Table name: arrendatarios
#
#  id                 :integer          not null, primary key
#  nombre             :string(255)
#  rif                :string(255)
#  direccion          :string(255)
#  telefono           :string(255)
#  nombre_rl          :string(255)
#  cedula_rl          :string(255)
#  email_rl           :string(255)
#  telefono_rl        :string(255)
#  mall_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  registro_mercantil :text
#

class Arrendatario < ActiveRecord::Base
  belongs_to :mall
  has_many :tiendas

  before_destroy :confirm_presence_of_tiendas

  validates :nombre, :rif, :direccion, :telefono, :telefono_rl, :nombre_rl, :cedula_rl, :mall_id, presence: true
  validates :nombre, uniqueness: true

  private
  def confirm_presence_of_tiendas
    if tiendas.any?
      return false
    end
  end

  def self.valid_arrendatarios(user)
    return Arrendatario.where(mall_id: user.mall_id).order(:nombre)
  end
end
