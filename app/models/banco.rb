# == Schema Information
#
# Table name: bancos
#
#  id         :integer          not null, primary key
#  nombre     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Banco < ActiveRecord::Base

  has_many   :cuenta_bancaria
  belongs_to :mall

  validates :nombre, presence: true
  validates_uniqueness_of :nombre, scope: :mall_id, message: 'del banoco ya está en uso'

  before_destroy :confirm_presence_of_ctas_bancarias

   private
    def confirm_presence_of_ctas_bancarias
      if cuenta_bancaria.any?
        return false
      end
    end

  def self.valid_bancos(user)
    where(mall_id: user.mall_id)
  end

end
