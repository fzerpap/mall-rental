# == Schema Information
#
# Table name: monedas
#
#  id         :integer          not null, primary key
#  nombre     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Moneda < ActiveRecord::Base
  has_many :pais
  validates :nombre, uniqueness: true
  validates :nombre, presence: true
end
