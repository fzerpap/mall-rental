# == Schema Information
#
# Table name: cuenta_bancaria
#
#  id            :integer          not null, primary key
#  nro_cta       :string(255)
#  tipo_cuenta   :string(255)
#  beneficiario  :string(255)
#  doc_identidad :string(255)
#  banco_id      :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class CuentaBancarium < ActiveRecord::Base

  belongs_to :banco
  has_one :mall, through: :banco
  has_many :pago_alquilers

  validates :nro_cta, presence: true
  validates_uniqueness_of :nro_cta, scope: :banco_id, message: 'ya está en uso'

  before_destroy :confirm_presence_of_pagos

  private
  def confirm_presence_of_ctas_pagos
    if pago_alquilers.any?
      return false
    end
  end
end
