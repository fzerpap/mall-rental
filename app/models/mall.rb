
class Mall < ActiveRecord::Base
  has_many :nivel_malls, dependent: :destroy
  belongs_to :pai
  has_many :actividad_economicas, dependent: :destroy
  has_many :users
  has_many :bancos
  has_many :cuenta_bancaria, through: :bancos, dependent: :destroy

  has_many :locals, dependent: :destroy
  has_many :tipo_locals, through: :locals,dependent: :destroy
  has_many :arrendatarios, dependent: :destroy
  has_many :tiendas, through: :locals, dependent: :destroy
  has_many :user_tiendas, through: :tiendas, dependent: :destroy
  has_many :contrato_alquilers, through: :tiendas, dependent: :destroy
  has_many :calendario_no_laborables
  has_many :cambio_monedas

  has_and_belongs_to_many :roles
  accepts_nested_attributes_for :roles

  has_many :plantilla_contrato_alquilers
  has_many :clientes

  validates :nombre, :abreviado, :rif, :direccion_fiscal, :telefono, :pai_id, presence: true
  validates :rif,:nombre,:abreviado, uniqueness: true

  before_destroy :confirm_presence_of_users

  def confirm_presence_of_users
    if users.any?
      return false
    end
  end

  def self.malls_without_admin
    return Mall.where.not(id: Mall.joins(:users).merge(User.joins(:role).where(roles: {role_type: Role.role_types[:administrador_cliente]})))
  end

  def nivel_mall_stats(nivel_mall_id)
    return self.nivel_malls unless nivel_mall_id.present?
    self.nivel_malls.where(id: nivel_mall_id)
  end

  def tipo_locals_stats(tipo_local_id)
    return TipoLocal.find_by_sql [
       "SELECT DISTINCT
          tipo_locals.*
        FROM
          public.malls,
          public.tiendas,
          public.locals,
          public.tipo_locals
        WHERE
          malls.id = #{self.id} AND
          malls.id = locals.mall_id AND
          locals.id = tiendas.local_id AND
          locals.tipo_local_id = tipo_locals.id;"] unless tipo_local_id.present?
    return TipoLocal.find_by_sql [
      "SELECT DISTINCT
        tipo_locals.*
      FROM
        public.malls,
        public.tiendas,
        public.locals,
        public.tipo_locals
      WHERE
        malls.id = #{self.id} AND
        malls.id = locals.mall_id AND
        locals.id = tiendas.local_id AND
        tipo_locals.id = ? AND
        locals.tipo_local_id = tipo_locals.id;", tipo_local_id]
  end

  def actividad_economicas_stats(actividad_economica_id)
    return ActividadEconomica.find_by_sql [
      "SELECT
        actividad_economicas.*
      FROM
        public.malls,
        public.tiendas,
        public.locals,
        public.actividad_economicas
      WHERE
        malls.id = #{self.id} AND
        malls.id = locals.mall_id AND
        locals.id = tiendas.local_id AND
        actividad_economicas.id = tiendas.actividad_economica_id;"] unless actividad_economica_id.present?
    return ActividadEconomica.find_by_sql [
    "SELECT
        actividad_economicas.*
      FROM
        public.malls,
        public.tiendas,
        public.locals,
        public.actividad_economicas
      WHERE
        malls.id = #{self.id} AND
        malls.id = locals.mall_id AND
        locals.id = tiendas.local_id AND
        actividad_economicas.id = ? AND
        actividad_economicas.id = tiendas.actividad_economica_id;", actividad_economica_id]
  end
end
