puts "INICIALIZANDO LOS TIPOS DE SERVICIOS"
TipoServicio.create!([{tipo: 'Mall'}, {tipo: 'Mall Rental'}, {tipo: 'Mall Condominio'}])

mall = TipoServicio.find_by(tipo: 'Mall')
mall_rental = TipoServicio.find_by(tipo: 'Mall Rental')
mall_condominio = TipoServicio.find_by(tipo: 'Mall Condominio')

puts "INICIALIZANDO LOS ROLES"

#SUPER ADMINISTRADOR DEL SISTEMA
admin_role = Role.create!(name: 'Super Usuario Sistema MallRental', permissions: Permission.where(name: 'manage'), role_type: Role.role_types[:administrador_sistema], tipo_servicio: mall)


# ROLES DE MALL
administrador_mall = Role.create(name: 'Administrador Mall', permissions: Permission.where(name: ['manage'], subject_class: ['ActividadEconomica', 'NivelMall', 'CalendarioNoLaborable', 'CambioMoneda', 'Local', 'Arrendatario', 'Tienda', 'ContratoAlquiler', 'UserTienda', 'PagoAlquiler', 'estadisticas']) + Permission.where(name: ['mf_mensuales', 'mf_mall_tiendas', 'mf_cobranza'], subject_class: 'VentaDiarium'), role_type: Role.role_types[:cliente_mall], tipo_servicio: mall )
super_user_mall = Role.create!(name: 'Super Usuario Mall', permissions: Permission.where(name: 'manage', subject_class: ['mall_user']), role_type: Role.role_types[:administrador_cliente], tipo_servicio: mall)
propietario_mall = Role.create!(name: 'Propietario Mall', permissions: Permission.where(name: ['manage'], subject_class: ['PagoAlquiler', 'estadisticas']), role_type: Role.role_types[:cliente_mall], tipo_servicio: mall)
gestor_alquileres = Role.create!(name: 'Gestor de Alquileres Mall', role_type: Role.role_types[:cliente_mall], tipo_servicio: mall)
gerente_tienda = Role.create!(name: 'Gerente de Tienda Mall', permissions: Permission.where(name: ['index'], subject_class: ['VentaDiarium']) ,role_type: Role.role_types[:cliente_tienda], tipo_servicio: mall)
gerente_tienda.update(permissions: Permission.where(name: 'manage', subject_class: 'PagoAlquiler'))
administrador_tienda = Role.create!(name: 'Administrador de Tienda Mall', permissions: Permission.where(name: ['index'], subject_class: ['VentaDiarium']), role_type: Role.role_types[:cliente_tienda], tipo_servicio: mall)
administrador_tienda.update(permissions: Permission.where(name: 'manage', subject_class: 'PagoAlquiler'))
propietario_tienda = Role.create!(name: 'Propietario de Tienda Mall', role_type: Role.role_types[:cliente_tienda], tipo_servicio: mall)

# ROLES DE MALL RENTAL
administrador_mall_rental = Role.create!(name: 'Administrador Mall Rental', permissions: Permission.where(name: ['manage'], subject_class: ['ActividadEconomica', 'NivelMall', 'CalendarioNoLaborable', 'CambioMoneda', 'Local', 'Arrendatario', 'Tienda', 'ContratoAlquiler', 'UserTienda', 'estadisticas']) + Permission.where(name: ['index', 'mf_new_cheque_efectivo', 'mf_facturas_tiendas', 'mf_pagos_mensuales'], subject_class: ['PagoAlquiler']) + Permission.where(name: ['mf_mensuales', 'mf_mall_tiendas', 'mf_cobranza'], subject_class: ['VentaDiarium']), role_type: Role.role_types[:cliente_mall], tipo_servicio: mall_rental)
super_user_mall_rental = Role.create!(name: 'Super Usuario Mall Rental', permissions: Permission.where(name: 'manage', subject_class: ['mall_user']), role_type: Role.role_types[:administrador_cliente],tipo_servicio: mall_rental)
propietario_mall_rental = Role.create!(name: 'Propietario Mall Rental', permissions: Permission.where(name: ['manage'], subject_class: ['PagoAlquiler', 'estadisticas']), role_type: Role.role_types[:cliente_mall], tipo_servicio: mall_rental)
gestor_alquileres_rental = Role.create!(name: 'Gestor de Alquileres Mall Rental', role_type: Role.role_types[:cliente_mall], tipo_servicio: mall_rental)
gerente_tienda_rental = Role.create!(name: 'Gerente de Tienda Mall Rental', permissions: (Permission.where(name: ['index'], subject_class: ['VentaDiarium']) + Permission.where(name: 'manage', subject_class: 'PagoAlquiler')) ,role_type: Role.role_types[:cliente_tienda], tipo_servicio: mall_rental)
administrador_tienda_rental = Role.create!(name: 'Administrador de Tienda Mall Rental', permissions: Permission.where(name: ['index'], subject_class: ['VentaDiarium']) + Permission.where(name: 'manage', subject_class: 'PagoAlquiler'), role_type: Role.role_types[:cliente_tienda], tipo_servicio: mall_rental)
propietario_tienda_rental = Role.create!(name: 'Propietario de Tienda Mall Rental', role_type: Role.role_types[:cliente_tienda], tipo_servicio: mall_rental)

# ROLES DE MALL CONDOMINIO
administrador_mall_condominio = Role.create!(name: 'Administrador Mall Condominio', permissions: Permission.where(name: ['manage'], subject_class: ['ActividadEconomica', 'NivelMall', 'CalendarioNoLaborable', 'CambioMoneda', 'Local', 'Arrendatario', 'Tienda', 'ContratoAlquiler', 'UserTienda', 'PagoAlquiler', 'estadisticas']), role_type: Role.role_types[:cliente_mall], tipo_servicio: mall_rental)
super_user_mall_condominio = Role.create!(name: 'Super Usuario Mall Condominio', permissions: Permission.where(name: 'manage', subject_class: ['mall_user']), role_type: Role.role_types[:administrador_cliente],tipo_servicio: mall_condominio)
propietario_mall_condominio = Role.create!(name: 'Propietario Mall Condominio', permissions: Permission.where(name: ['manage'], subject_class: ['PagoAlquiler' , 'estadisticas']), role_type: Role.role_types[:cliente_mall], tipo_servicio: mall_condominio)
gestor_alquileres_condominio = Role.create!(name: 'Gestor de Alquileres Mall Condominio', role_type: Role.role_types[:cliente_mall], tipo_servicio: mall_condominio)
gerente_tienda_condominio = Role.create!(name: 'Gerente de Tienda Mall Condominio', permissions: Permission.where(name: ['index'], subject_class: ['Venta']) ,role_type: Role.role_types[:cliente_tienda], tipo_servicio: mall_condominio)
gerente_tienda_condominio.update(permissions: Permission.where(name: 'manage', subject_class: 'PagoAlquiler'))
administrador_tienda_condominio = Role.create!(name: 'Administrador de Tienda Mall Condominio', permissions: Permission.where(name: ['index'], subject_class: ['Venta']), role_type: Role.role_types[:cliente_tienda], tipo_servicio: mall_condominio)
administrador_tienda_condominio.update(permissions: Permission.where(name: 'manage', subject_class: 'PagoAlquiler'))
propietario_tienda_condominio = Role.create!(name: 'Propietario de Tienda Mall Condominio', role_type: Role.role_types[:cliente_tienda], tipo_servicio: mall_condominio)


puts "INICIALIZANDO EL USUARIO SUPER ADMINISTRADOR MALL RENTAL"
User.create!(name: 'Super Administrador', username: 'mall_admin', password: '12345678',
             email: 'surf.airwaves@hotmail.com', cellphone: '0414-2312322', role: Role.find(1), avatar: '')

puts "INICIALIZANDO MONEDAS"
bs =    Moneda.create!(nombre: 'Bolívares')
peso =  Moneda.create!(nombre: 'Pesos Colombianos')
dolar = Moneda.create!(nombre: 'Dolares')
euro =  Moneda.create!(nombre: 'Euros')

puts "INICIALIZANDO CAMBIOS DE MONEDA"
CambioMoneda.create!(fecha: Date.today, cambio_ml_x_usd: 600)

puts "INICIALIZANDO IDIOMAS"
es = Idioma.create!(nombre: 'Español')
en = Idioma.create!(nombre: 'Inglés')

puts "INICIALIZANDO PAISES"
Pai.create!(nombre: 'Venezuela', moneda: bs, idioma: es)
Pai.create!(nombre: 'Colombia', moneda: peso, idioma: es)
Pai.create!(nombre: 'Estados Unidos', moneda: dolar, idioma: en)

puts "INICIALIZANDO TIPOS DE LOCALES"
TipoLocal.create!(tipo: 'Comercial')
TipoLocal.create!(tipo: 'Empresarial')

puts "INICIALIZANDO TIPOS DE CANON DE ALQUILER"
TipoCanonAlquiler.create!([{tipo: 'Fijo'}, {tipo: 'Variable Venta Bruta'},
                           {tipo: 'Variable Venta Neta'}, {tipo: 'Fijo&Variable Venta Bruta'},
                           {tipo: 'Fijo&Variable Venta Neta'}, {tipo: 'Exento'}])

puts "INICIALIZANDO TIPOS DE CONTRATOS DE SERVICIOS"
TipoContratoServicio.create!([{tipo: 'Servicios x Locatario'}, {tipo: 'Venta de Software'},
                           {tipo: 'Servicios x %Ingresos x Alquiler'}, {tipo: 'Servicios x %Gastos de Condominio'}])


puts "INICIALIZANDO NRO DE CONTROL"
NumerosControl.create!(nro_contrato: 1)

