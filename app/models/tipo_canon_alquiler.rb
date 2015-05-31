# == Schema Information
#
# Table name: tipo_canon_alquilers
#
#  id         :integer          not null, primary key
#  tipo       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class TipoCanonAlquiler < ActiveRecord::Base
  has_many :contrato_alquilers
  # validates :tipo, inclusion: { in: ['Canon fijo', 'Canon fijo y porcentaje ventas', 'Porcentaje de ventas']}

  def tipo_nombre
    self.tipo.humanize.titleize
  end
end
