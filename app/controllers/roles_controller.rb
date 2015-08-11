class RolesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_role, only: [:show, :edit, :update, :destroy]

  # GET /roles
  # GET /roles.json
  def index
    @roles = Role.all_valids
  end

  # GET /roles/1
  # GET /roles/1.json
  def show
  end

  # GET /roles/new
  def new
    @role = Role.new
  end

  # GET /roles/1/edit
  def edit
  end

  # POST /roles
  # POST /roles.json
  def create
    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        format.html { redirect_to @role, notice: 'Rol creado satisfactoriamente.' }
        format.json { render action: 'show', status: :created, location: @role }
      else
        format.html { render action: 'new' }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to @role, notice: 'El rol fue actualizado satisfactoriamente.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    respond_to do |format|
      if @role.destroy
        format.html { redirect_to roles_path, notice: "Rol #{@role.name} eliminado satisfactoriamente"  }
        format.json { head :no_content }
      else
        format.html { redirect_to roles_path, alert: "El rol #{@role.name} no puede ser eliminado, porque tiene usuarios asociados"  }
        format.json { head :no_content }
      end
    end
  end


  def assign_role_mall

  end

  def set_mall
    @mall = Mall.find_by(id: params[:mall_id])
    render partial: 'mall_roles'
  end

  def save_mall_roles
    @mall = Mall.find_by(id: params_id)
    puts role_mall_params
    if @mall.update(role_mall_params)
      redirect_to assign_role_mall_path, notice: "Roles para el mall #{@mall.nombre} asignados satisfactoriamente"
    else
      redirect_to assign_role_mall_path, alert: "Error asignando los roles."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.require(:role).permit(:name, :role_type, :tipo_servicio_id, permission_ids: [])
    end

    def role_mall_params
      params.require(:mall).permit(role_ids: [])
    end
end
