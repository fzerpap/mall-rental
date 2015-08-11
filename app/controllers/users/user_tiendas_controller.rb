class Users::UserTiendasController < ApplicationController
  before_action :authenticate_user!
  authorize_resource class: 'UserTienda'
  before_action :set_tienda, only: [:index, :new, :create, :destroy, :show, :edit, :update]
  before_action :set_user, only: [:destroy, :show, :edit, :update]
  before_action :set_roles, only: [:new, :edit]
  @@password = ""

  def index

  end

  def new
    @tienda = current_user.mall.tiendas.find_by(id: params[:id])
    @user = @tienda.users.build
  end

  def create
    @user = @tienda.users.build(user_tienda_params.merge(mall_id: @tienda.mall.id))
    @@password = user_tienda_params[:password]
    respond_to do |format|
      if @user.save
        PasswordMailer.send_password(@user, @@password).deliver
        format.html { redirect_to  user_tiendas_path(tienda: @user.tienda.nombre, id: @user.tienda.id), notice: "#{@user.tienda.mall.nombre} - #{@user.tienda.nombre} - Usuario creado exitosamente" }
        format.json { render :show, status: :created, location: @user }
      else
        set_roles
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @pass = @@password
    @@password = ""
  end

  def destroy
    if @user.mall.id == current_user.mall.id && (@user.role.cliente_tienda?)
      if @user.destroy
        redirect_to user_tiendas_path(tienda: @tienda.nombre, id: @tienda.id), alert: "Usuario eliminado satisfactoriamente." and return
      end
    else
      redirect_to user_tiendas_path(tienda: @tienda.nombre, id: @tienda.id), alert: 'No Autorizado' and return
    end
  end

  def edit

  end

  def update
    if @user.mall.id == current_user.mall.id && @user.role.cliente_tienda?
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to user_tiendas_path(tienda: @user.tienda.nombre, id: @user.tienda.id), notice: 'El usuario mall ha sido actualizado.' }
          format.json { render :show, status: :ok, location: @user }
        else
          set_roles
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to mall_users_path, alert: 'No Autorizado' and return
    end
  end

  private

    def set_user
      @user = @tienda.users.find_by(id: ActionController::Parameters.new(us: params[:us]).permit(:us)[:us])
    end

    def user_tienda_params
      params.require(:user).permit(:name, :username, :email, :password, :cellphone, :role_id, :tienda, :locked)
    end

    def set_tienda
      @tienda = current_user.mall.tiendas.find_by(id: ActionController::Parameters.new(id: params[:id]).permit(:id)[:id])
    end

  def set_roles

    @roles = Role.joins(:malls).where(malls: {id: current_user.mall.id} ,role_type: Role.role_types[:cliente_tienda])

    if @roles.blank?
      redirect_to new_role_path, alert: 'No existen roles para clientes tienda.' and return
    end
  end

end