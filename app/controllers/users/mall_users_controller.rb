class Users::MallUsersController < ApplicationController
  before_action :authenticate_user!
  authorize_resource class: :mall_user
  before_action :set_user, only: [:destroy, :show, :edit, :update]
  before_action :set_roles, only: [:new, :edit]
  before_action :check_user_mall
  @@password = ""

  def index
    @mall_users = User.joins(:role).where(mall_id: current_user.mall.id, roles: {role_type: Role.role_types[:cliente_mall]})
  end

  def new
     @mall_user ||= User.new
  end

  def create
    @mall_user = User.new(mall_user_params.merge(mall_id: current_user.mall.id))
    @@password = mall_user_params[:password]
    respond_to do |format|
      if @mall_user.save
        PasswordMailer.send_password(@mall_user, @@password).deliver
        format.html { redirect_to  mall_user_path(@mall_user), notice: 'El usuario de MallRental se ha creado exitosamente.' }
        format.json { render :show, status: :created, location: @mall_user }
      else
        set_roles
        format.html { render :new }
        format.json { render json: @mall_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @pass = @@password
    @@password = ""
  end

  def destroy
    if @user.mall.id == current_user.mall.id && (@user.role.cliente_mall?)
      if @user.destroy
        redirect_to mall_users_path, alert: 'Usuario eliminado satisfactoriamente.' and return
      end
    else
      redirect_to mall_users_path, alert: 'No Autorizado' and return
    end
  end

  def edit

  end

  def update
    if @user.mall.id == current_user.mall.id && @user.role.cliente_mall?
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to mall_user_path(@user), notice: 'El usuario mall ha sido actualizado.' }
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
    def mall_user_params
      params.require(:user).permit(:name, :username, :email, :password, :cellphone, :role_id, :locked)
    end


    def self.permission
      'mall_user'
    end

    def set_roles

      @roles = Role.joins(:malls).where(malls: {id: current_user.mall.id} ,role_type: Role.role_types[:cliente_mall])

       if @roles.blank?
        redirect_to new_role_path, alert: 'No existen roles para clientes mall.' and return
      end
    end
end