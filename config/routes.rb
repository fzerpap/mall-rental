Myapp::Application.routes.draw do

  root to: 'static#index'

  devise_for :users

  devise_scope :user do
    get 'users/new', to: 'users/registrations#new_user'
    post 'users/create_user',
        to: 'users/registrations#create_user'
    get 'user/show/:id', to: 'users/registrations#show', as: :user_show
    get 'users/index', to: 'users/registrations#index'
    get 'users/edit_user/:id', to: 'users/registrations#edit_user', as: :user_edit_user
    post 'users/update_user', to: 'users/registrations#update_user'
    delete 'users/delete_user/:id', to: 'users/registrations#delete_user', as: :user_delete_user
    get 'profile', to: 'users/profiles#profile'
    get 'profile/edit', to: 'users/profiles#edit'
    post 'profile/update', to: 'users/profiles#update'
  end

  scope module: 'users' do
    resources :mall_users
    resources :user_tiendas
  end

  resources :roles

  resources :locals

  resources :malls

  resources :nivel_malls

  resources :pais

  get 'locals' => 'locals#index', as: :local_index

  get 'locals/new' => 'locals#new'

  get 'nivel_malls/index/:mall_id' => 'nivel_malls#index', as: :nivel_malls_index

  get 'nivel_malls/new/:mall_id' => 'nivel_malls#new'

  get 'nivel_malls/test_ajax' => 'nivel_malls#test_ajax'

  get 'actividad_economicas' => 'actividad_economicas#index', as: :actividad_economicas

  get 'actividad_economica' => 'actividad_economicas#show'
  
  resources :tipo_canon_alquilers

  resources :cambio_monedas
  post 'cambio_monedas/mf_cambio_moneda'
  
  resources :actividad_economicas

  resources :calendario_no_laborables

  resources :arrendatarios

  resources :tiendas
  post 'tiendas/mf_dynamic_filter'

  resources :ventas

  resources :contrato_alquilers

  get 'auditoria_ventas' => 'ventas#auditoria', as: :auditoria_ventas

  get 'ventas_tiendas/:tienda_id' => 'ventas#index', as: :ventas_tienda

  get 'ventas_mes_tiendas' => 'ventas#index', as: :ventas_mes_tienda

  get 'ventas_mall_tiendas' => 'ventas#mall_tiendas', as: :ventas_mall_tiendas

  get 'ventas_mensuales_mall' => 'ventas#mensuales', as: :ventas_mensuales_mall

  scope module: 'dynamic' do
    post 'dynamic_add_actividad/actividad'
    post 'dynamic_venta_diaria/venta'
    post 'dynamic_venta_diaria/guardar_ventas'
    post 'dynamic_venta_auditoria/auditoria'
    post 'dynamic_ventas_mes/ventas'
  end

  #CONTROLADOR DE NOTIFICACIONES MAILERS
  get 'notificar_usuarios_mall', to: 'mail_notifications#mf_notify_tiendas_mall'
end
