# == Schema Information
#
# Table name: nivel_malls
#
#  id         :integer          not null, primary key
#  nombre     :string(255)
#  mall_id    :integer
#  created_at :datetime
#  updated_at :datetime
#


class NivelMall < ActiveRecord::Base
  belongs_to :mall
  has_many :locals
  has_many :tiendas, through: :locals

  validates :nombre, :mall_id, presence: true
  validates_uniqueness_of :nombre, scope: :mall_id, message: 'ya está en uso'

  before_destroy :confirm_presence_of_locales

  def confirm_presence_of_locales
    if locals.any?
      return false
    end
  end


  def self.valid_nivel_malls(user)
    return NivelMall.where(mall_id: user.mall_id)
  end


end
