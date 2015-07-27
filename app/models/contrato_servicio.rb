class ContratoServicio < ActiveRecord::Base
  belongs_to :cliente
  belongs_to :precio_servicio
  belongs_to :tipo_contrato_servicio
  has_one :tipo_servicio, through: :cliente


  def self.format_number(numero)
    return ActionController::Base.helpers.number_to_currency(numero, separator: ',', delimiter: '.', format: "%n %u", unit: "")
  end

  def self.estado_title(estado)
    if estado
      return 'Activo'
    else
      return 'Inactivo'
    end
  end

  def self.format_fecha(fecha)
    return fecha.strftime("%d/%m/%Y")
  end


end
