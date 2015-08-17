class CalendarioNoLaborablesController < ApplicationController
  before_action :set_calendario_no_laborable, only: [:show, :edit, :update, :destroy]
  before_action :check_user_mall

  # GET /calendario_no_laborables
  # GET /calendario_no_laborables.json
  def index
    @mall = current_user.mall
    @calendario_no_laborables = @mall.calendario_no_laborables
  end

  # GET /calendario_no_laborables/1
  # GET /calendario_no_laborables/1.json
  def show
  end

  # GET /calendario_no_laborables/new
  def new
    @calendario_no_laborable = CalendarioNoLaborable.new
    @mall = current_user.mall

  end
  # GET /calendario_no_laborables/1/edit
  def edit
    @mall = current_user.mall
  end

  # POST /calendario_no_laborables
  # POST /calendario_no_laborables.json
  def create
    @calendario_no_laborable = CalendarioNoLaborable.new(calendario_no_laborable_params)

    respond_to do |format|
      if @calendario_no_laborable.save
        format.html { redirect_to calendario_no_laborables_path, notice: 'Fecha No Laborable se ha guardado exitosamente.' }
        format.json { render :index, status: :created, location: @calendario_no_laborable }
      else
        format.html { render :new }
        format.json { render json: @calendario_no_laborable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calendario_no_laborables/1
  # PATCH/PUT /calendario_no_laborables/1.json
  def update
    respond_to do |format|
      if @calendario_no_laborable.update(calendario_no_laborable_params)
        format.html { redirect_to calendario_no_laborables_path, notice: 'Fecha No Laborable se actualizo correctamente.' }
        format.json { render :index, status: :ok, location: @calendario_no_laborable }
      else
        format.html { render :edit }
        format.json { render json: @calendario_no_laborable.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calendario_no_laborables/1
  # DELETE /calendario_no_laborables/1.json
  def destroy
    @calendario_no_laborable.destroy
    respond_to do |format|
      format.html { redirect_to calendario_no_laborables_url, notice: 'Fecha No Laborable se elimino exitosamente.' }
      format.json { head :no_content }
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendario_no_laborable
      @calendario_no_laborable = CalendarioNoLaborable.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calendario_no_laborable_params
      params.require(:calendario_no_laborable).permit(:fecha, :motivo, :mall_id )
    end
end
