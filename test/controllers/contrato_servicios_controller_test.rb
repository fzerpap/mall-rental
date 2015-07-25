require 'test_helper'

class ContratoServiciosControllerTest < ActionController::TestCase
  setup do
    @contrato_servicio = contrato_servicios(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contrato_servicios)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contrato_servicio" do
    assert_difference('ContratoServicio.count') do
      post :create, contrato_servicio: { archivo_contrato: @contrato_servicio.archivo_contrato, contrato_ml: @contrato_servicio.contrato_ml, estado_contrato: @contrato_servicio.estado_contrato, fecha_fin: @contrato_servicio.fecha_fin, fecha_inicio: @contrato_servicio.fecha_inicio, locatarios: @contrato_servicio.locatarios, monto_ml: @contrato_servicio.monto_ml, moonto_usd: @contrato_servicio.moonto_usd, nro_contrato: @contrato_servicio.nro_contrato, porcIngresosAlquiler: @contrato_servicio.porcIngresosAlquiler }
    end

    assert_redirected_to contrato_servicio_path(assigns(:contrato_servicio))
  end

  test "should show contrato_servicio" do
    get :show, id: @contrato_servicio
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contrato_servicio
    assert_response :success
  end

  test "should update contrato_servicio" do
    patch :update, id: @contrato_servicio, contrato_servicio: { archivo_contrato: @contrato_servicio.archivo_contrato, contrato_ml: @contrato_servicio.contrato_ml, estado_contrato: @contrato_servicio.estado_contrato, fecha_fin: @contrato_servicio.fecha_fin, fecha_inicio: @contrato_servicio.fecha_inicio, locatarios: @contrato_servicio.locatarios, monto_ml: @contrato_servicio.monto_ml, moonto_usd: @contrato_servicio.moonto_usd, nro_contrato: @contrato_servicio.nro_contrato, porcIngresosAlquiler: @contrato_servicio.porcIngresosAlquiler }
    assert_redirected_to contrato_servicio_path(assigns(:contrato_servicio))
  end

  test "should destroy contrato_servicio" do
    assert_difference('ContratoServicio.count', -1) do
      delete :destroy, id: @contrato_servicio
    end

    assert_redirected_to contrato_servicios_path
  end
end
