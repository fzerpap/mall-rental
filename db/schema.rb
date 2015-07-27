# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150726013644) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actividad_economicas", force: true do |t|
    t.string   "nombre"
    t.integer  "mall_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "actividad_economicas", ["mall_id"], name: "index_actividad_economicas_on_mall_id", using: :btree

  create_table "arrendatarios", force: true do |t|
    t.string   "nombre"
    t.string   "rif"
    t.string   "direccion"
    t.string   "telefono"
    t.string   "nombre_rl"
    t.string   "cedula_rl"
    t.string   "email_rl"
    t.string   "telefono_rl"
    t.integer  "mall_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "registro_mercantil"
  end

  add_index "arrendatarios", ["mall_id"], name: "index_arrendatarios_on_mall_id", using: :btree

  create_table "bancos", force: true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calendario_no_laborables", force: true do |t|
    t.date     "fecha"
    t.string   "motivo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mall_id"
  end

  add_index "calendario_no_laborables", ["mall_id"], name: "index_calendario_no_laborables_on_mall_id", using: :btree

  create_table "cambio_monedas", force: true do |t|
    t.date     "fecha"
    t.decimal  "cambio_ml_x_usd"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mall_id"
  end

  add_index "cambio_monedas", ["mall_id"], name: "index_cambio_monedas_on_mall_id", using: :btree

  create_table "canon_alquilers", force: true do |t|
    t.date     "fecha"
    t.decimal  "canon_fijo_ml"
    t.decimal  "canon_fijo_usd"
    t.decimal  "porc_canon_ventas"
    t.integer  "monto_minimo_ventas"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clientes", force: true do |t|
    t.string   "nombre"
    t.string   "RIF"
    t.string   "direccion"
    t.string   "telefono"
    t.string   "nombre_rl"
    t.string   "profesion_rl"
    t.string   "cedula_rl"
    t.string   "email_rl"
    t.string   "telefono_rl"
    t.string   "nombre_contacto"
    t.string   "profesion_contacto"
    t.string   "cedula_contacto"
    t.string   "email_contacto"
    t.string   "telefono_contacto"
    t.integer  "mall_id"
    t.integer  "tipo_servicio_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clientes", ["mall_id"], name: "index_clientes_on_mall_id", using: :btree
  add_index "clientes", ["tipo_servicio_id"], name: "index_clientes_on_tipo_servicio_id", using: :btree

  create_table "cobranza_alquilers", force: true do |t|
    t.string   "nro_recibo"
    t.date     "fecha_recibo_cobro"
    t.integer  "anio_alquiler"
    t.integer  "mes_alquiler"
    t.float    "monto_canon_fijo",     default: 0.0
    t.float    "monto_canon_variable", default: 0.0
    t.float    "monto_alquiler"
    t.float    "monto_alquiler_usd"
    t.boolean  "facturado",            default: true
    t.float    "saldo_deudor"
    t.integer  "tienda_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cobranza_alquilers", ["tienda_id"], name: "index_cobranza_alquilers_on_tienda_id", using: :btree

  create_table "contrato_alquilers", force: true do |t|
    t.string   "nro_contrato"
    t.date     "fecha_inicio"
    t.date     "fecha_fin"
    t.string   "archivo_contrato"
    t.decimal  "canon_fijo_ml"
    t.decimal  "canon_fijo_usd"
    t.decimal  "porc_canon_ventas"
    t.decimal  "monto_minimo_ventas"
    t.boolean  "estado_contrato"
    t.integer  "tipo_canon_alquiler"
    t.integer  "tienda_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "requerida_venta"
    t.integer  "tipo_canon_alquiler_id"
  end

  add_index "contrato_alquilers", ["tienda_id"], name: "index_contrato_alquilers_on_tienda_id", using: :btree

  create_table "contrato_servicios", force: true do |t|
    t.string   "nro_contrato"
    t.date     "fecha_inicio"
    t.date     "fecha_fin"
    t.string   "archivo_contrato"
    t.float    "monto_ml"
    t.float    "monto_usd"
    t.float    "porc_ingresos_alquiler",    default: 0.0
    t.boolean  "estado_contrato",           default: true
    t.integer  "locatarios",                default: 0
    t.boolean  "contrato_ml",               default: true
    t.integer  "precio_servicio_id"
    t.integer  "tipo_contrato_servicio_id"
    t.integer  "cliente_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contrato_servicios", ["cliente_id"], name: "index_contrato_servicios_on_cliente_id", using: :btree
  add_index "contrato_servicios", ["precio_servicio_id"], name: "index_contrato_servicios_on_precio_servicio_id", using: :btree
  add_index "contrato_servicios", ["tipo_contrato_servicio_id"], name: "index_contrato_servicios_on_tipo_contrato_servicio_id", using: :btree

  create_table "cuenta_bancaria", force: true do |t|
    t.string   "nro_cta"
    t.string   "tipo_cuenta"
    t.string   "beneficiario"
    t.string   "doc_identidad"
    t.integer  "banco_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mall_id"
  end

  add_index "cuenta_bancaria", ["banco_id"], name: "index_cuenta_bancaria_on_banco_id", using: :btree
  add_index "cuenta_bancaria", ["mall_id"], name: "index_cuenta_bancaria_on_mall_id", using: :btree

  create_table "detalle_pago_alquilers", force: true do |t|
    t.float    "monto",               default: 0.0
    t.integer  "pago_alquiler_id"
    t.integer  "factura_alquiler_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "detalle_pago_alquilers", ["factura_alquiler_id"], name: "index_detalle_pago_alquilers_on_factura_alquiler_id", using: :btree
  add_index "detalle_pago_alquilers", ["pago_alquiler_id"], name: "index_detalle_pago_alquilers_on_pago_alquiler_id", using: :btree

  create_table "documento_ventas", force: true do |t|
    t.string   "titulo"
    t.string   "nombre"
    t.integer  "venta_mensual_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documento_ventas", ["venta_mensual_id"], name: "index_documento_ventas_on_venta_mensual_id", using: :btree

  create_table "estado_facturas", force: true do |t|
    t.string   "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "factura_alquilers", force: true do |t|
    t.date     "fecha"
    t.string   "nro_factura"
    t.float    "monto_factura",        default: 0.0
    t.float    "monto_abono",          default: 0.0
    t.float    "saldo_deudor"
    t.boolean  "canon_fijo"
    t.integer  "cobranza_alquiler_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "estado_factura_id"
  end

  add_index "factura_alquilers", ["cobranza_alquiler_id"], name: "index_factura_alquilers_on_cobranza_alquiler_id", using: :btree
  add_index "factura_alquilers", ["estado_factura_id"], name: "index_factura_alquilers_on_estado_factura_id", using: :btree

  create_table "idiomas", force: true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locals", force: true do |t|
    t.string   "foto"
    t.string   "nro_local"
    t.string   "ubicacion_pasillo"
    t.integer  "tipo_local_id"
    t.integer  "nivel_mall_id"
    t.integer  "mall_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "area_planta",       default: 0.0
    t.decimal  "area_terraza",      default: 0.0
    t.decimal  "area_mezanina",     default: 0.0
    t.integer  "tipo_estado_local"
  end

  add_index "locals", ["mall_id"], name: "index_locals_on_mall_id", using: :btree
  add_index "locals", ["nivel_mall_id"], name: "index_locals_on_nivel_mall_id", using: :btree
  add_index "locals", ["tipo_local_id"], name: "index_locals_on_tipo_local_id", using: :btree

  create_table "malls", force: true do |t|
    t.string   "nombre"
    t.string   "abreviado"
    t.string   "rif"
    t.string   "direccion_fiscal"
    t.string   "telefono"
    t.integer  "pai_id"
    t.integer  "cuenta_bancarium_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "malls", ["cuenta_bancarium_id"], name: "index_malls_on_cuenta_bancarium_id", using: :btree
  add_index "malls", ["pai_id"], name: "index_malls_on_pai_id", using: :btree

  create_table "malls_roles", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "mall_id"
  end

  add_index "malls_roles", ["mall_id", "role_id"], name: "index_malls_roles_on_mall_id_and_role_id", using: :btree

  create_table "monedas", force: true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nivel_malls", force: true do |t|
    t.string   "nombre"
    t.integer  "mall_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nivel_malls", ["mall_id"], name: "index_nivel_malls_on_mall_id", using: :btree

  create_table "nro_facturas", force: true do |t|
    t.integer  "numero"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nro_recibos", force: true do |t|
    t.integer  "numero"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nro_recibos_cobros", force: true do |t|
    t.integer  "numero"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "numeros_controls", force: true do |t|
    t.integer  "nro_contrato"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pago_alquilers", force: true do |t|
    t.string   "nro_recibo"
    t.date     "fecha"
    t.string   "nro_cheque_confirmacion"
    t.string   "archivo_transferencia"
    t.string   "banco_emisor"
    t.integer  "tipo_pago"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cuenta_bancarium_id"
    t.decimal  "monto"
    t.decimal  "monto_usd"
    t.boolean  "conciliado",              default: true
  end

  create_table "pais", force: true do |t|
    t.string   "nombre"
    t.integer  "idioma_id"
    t.integer  "moneda_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pais", ["idioma_id"], name: "index_pais_on_idioma_id", using: :btree
  add_index "pais", ["moneda_id"], name: "index_pais_on_moneda_id", using: :btree

  create_table "permissions", force: true do |t|
    t.string   "subject_class", limit: 60, default: ""
    t.string   "action",        limit: 50, default: "", null: false
    t.string   "name",          limit: 50, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions_roles", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "permission_id"
  end

  add_index "permissions_roles", ["permission_id", "role_id"], name: "index_permissions_roles_on_permission_id_and_role_id", using: :btree

  create_table "plantilla_contrato_alquilers", force: true do |t|
    t.string   "nombre"
    t.text     "contenido"
    t.integer  "mall_id"
    t.integer  "tipo_canon_alquiler_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plantilla_contrato_alquilers", ["mall_id"], name: "index_plantilla_contrato_alquilers_on_mall_id", using: :btree
  add_index "plantilla_contrato_alquilers", ["tipo_canon_alquiler_id"], name: "index_plantilla_contrato_alquilers_on_tipo_canon_alquiler_id", using: :btree

  create_table "precio_servicios", force: true do |t|
    t.date     "fecha"
    t.float    "precio_usd"
    t.integer  "tipo_servicio_id"
    t.integer  "tipo_contrato_servicio_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "precio_servicios", ["tipo_contrato_servicio_id"], name: "index_precio_servicios_on_tipo_contrato_servicio_id", using: :btree
  add_index "precio_servicios", ["tipo_servicio_id"], name: "index_precio_servicios_on_tipo_servicio_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name",             limit: 50, default: "", null: false
    t.integer  "role_type",                   default: 0,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tipo_servicio_id"
  end

  add_index "roles", ["tipo_servicio_id"], name: "index_roles_on_tipo_servicio_id", using: :btree

  create_table "tiendas", force: true do |t|
    t.string   "nombre"
    t.date     "fecha_apertura"
    t.date     "fecha_cierre"
    t.boolean  "abierta"
    t.date     "fecha_fin_contrato_actual"
    t.integer  "local_id"
    t.integer  "actividad_economica_id"
    t.integer  "arrendatario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "monto_garantia",            precision: 30, scale: 2
    t.decimal  "monto_garantia_usd",        precision: 30, scale: 2
    t.string   "codigo_contable"
  end

  add_index "tiendas", ["actividad_economica_id"], name: "index_tiendas_on_actividad_economica_id", using: :btree
  add_index "tiendas", ["arrendatario_id"], name: "index_tiendas_on_arrendatario_id", using: :btree
  add_index "tiendas", ["local_id"], name: "index_tiendas_on_local_id", using: :btree

  create_table "tipo_canon_alquilers", force: true do |t|
    t.string   "tipo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipo_contrato_servicios", force: true do |t|
    t.string   "tipo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipo_locals", force: true do |t|
    t.string   "tipo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipo_servicios", force: true do |t|
    t.string   "tipo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_tiendas", force: true do |t|
    t.integer  "user_id"
    t.integer  "tienda_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_tiendas", ["tienda_id"], name: "index_user_tiendas_on_tienda_id", using: :btree
  add_index "user_tiendas", ["user_id"], name: "index_user_tiendas_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "username",                          default: "",    null: false
    t.string   "encrypted_password",                default: "",    null: false
    t.string   "email",                             default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "unique_session_id",      limit: 20
    t.string   "name"
    t.string   "cellphone"
    t.string   "avatar"
    t.integer  "mall_id"
    t.boolean  "locked",                            default: false
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree

  create_table "venta_diaria", force: true do |t|
    t.date     "fecha"
    t.float    "monto"
    t.float    "monto_notas_credito", default: 0.0
    t.float    "monto_bruto"
    t.float    "monto_bruto_usd"
    t.float    "monto_costo_venta",   default: 0.0
    t.float    "monto_neto",          default: 0.0
    t.float    "monto_neto_usd",      default: 0.0
    t.boolean  "editable",            default: true
    t.integer  "venta_mensual_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "venta_diaria", ["venta_mensual_id"], name: "index_venta_diaria_on_venta_mensual_id", using: :btree

  create_table "venta_mensuals", force: true do |t|
    t.integer  "anio"
    t.integer  "mes"
    t.float    "monto"
    t.float    "monto_notas_credito", default: 0.0
    t.float    "monto_bruto"
    t.float    "monto_bruto_USD"
    t.float    "monto_costo_venta",   default: 0.0
    t.float    "monto_neto",          default: 0.0
    t.float    "monto_neto_USD",      default: 0.0
    t.boolean  "editable",            default: true
    t.integer  "tienda_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "venta_mensuals", ["tienda_id"], name: "index_venta_mensuals_on_tienda_id", using: :btree

end
