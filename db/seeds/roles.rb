#--- SEEDING ROLES, RECUERDE PRIMERO SEEDEAR LOS TIPOS DE SERVICIO ---#

mall = TipoServicio.find_by(tipo: 'Mall')
mall_rental = TipoServicio.find_by(tipo: 'Mall Rental')
mall_condominio = TipoServicio.find_by(tipo: 'Mall Condominio')

#SUPER ADMINISTRADOR DEL SISTEMA
admin_role = Role.create!(name: 'Super Usuario MallRental', permissions: Permission.where(name: 'manage'), role_type: Role.role_types[:administrador_sistema], tipo_servicio: mall)


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


puts "#---- ROLES -----#\n"