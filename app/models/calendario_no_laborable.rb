# == Schema Information
#
# Table name: calendario_no_laborables
#
#  id         :integer          not null, primary key
#  fecha      :date
#  motivo     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  mall_id    :integer
#


class CalendarioNoLaborable < ActiveRecord::Base
  validates :motivo, presence: true
  validates :fecha, presence: true, uniqueness: true
  has_many :malls

  def cantidad_dias_laborables(mes,anio,mall)
    cant_mes = Time.days_in_month(mes.to_i, anio.to_i)

    today = Time.now
    if (mes == today.strftime("%-m") && anio == today.strftime("%Y"))
      cant_mes =  today.strftime("%d").to_i
      hoy = today.strftime("%d").to_i
      aux = true
    else
      aux = false
      cant_mes = Time.days_in_month(mes.to_i, anio.to_i)
    end
    if aux
      dias = CalendarioNoLaborable.where('extract(year from fecha) = ? AND extract(month from fecha ) = ? AND extract(day from fecha )<= ? AND mall_id = ?', anio,mes,hoy.to_i, mall).count
    else
      dias = CalendarioNoLaborable.where('extract(year from fecha) = ? AND extract(month from fecha ) = ? AND mall_id = ?', anio,mes,mall).count
    end

    return (cant_mes-dias)
  end

  def self.is_no_lab(fecha,mall)
    return CalendarioNoLaborable.find_by('fecha = ? AND mall_id = ?',fecha,mall)

  end

  def self.cantidad_dias_no_lab(mall,mes,year)
    return CalendarioNoLaborable.where('extract(year from fecha) = ? AND extract(month from fecha) = ? AND mall_id = ?', year,mes,mall).count()
  end

end
