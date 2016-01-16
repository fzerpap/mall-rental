require 'test_helper'

class LocalTest < ActiveSupport::TestCase
  test "el local  debe tener valores" do
    local = Local.create()
    assert_not local.valid?, "Error: El local  no tiene valores"
  end
  test "el local  tiene todos los valores" do
    local = Local.create({nro_local: "AR-02",area_planta: 100,area_mezanina: 0,area_terraza: 0,mall_id: 1,nivel_mall_id: 1,tipo_local_id: 0,tipo_estado_local: 1})
    assert local.valid?, "Error: El local  tiene todos los valores"
  end
  test "el local  debe tener nro" do
    local = Local.create({nro_local: "",area_planta: 100,area_mezanina: 0,area_terraza: 0,mall_id: 1,nivel_mall_id: 1,tipo_local_id: 0,tipo_estado_local: 1})
    assert_not local.valid?, "Error: El local  no tiene nombre"
  end
  test "el local  debe estar asociado a un mall" do
    local = Local.create({nro_local: "AR-02",area_planta: 100,area_mezanina: 0,area_terraza: 0,mall_id: nil,nivel_mall_id: 1,tipo_local_id: 0,tipo_estado_local: 1})
    assert_not local.valid?, "Error: El local  debe estar asociado a un mall"
  end
  test "el local  debe estar asociado a un nivel de mall" do
    local = Local.create({nro_local: "AR-02",area_planta: 100,area_mezanina: 0,area_terraza: 0,mall_id: 1,nivel_mall_id: nil,tipo_local_id: 0,tipo_estado_local: 1})
    assert_not local.valid?, "Error: El local  debe estar asociado a un nivel de  mall"
  end
  test "el local  debe estar asociado a un tipo de local" do
    local = Local.create({nro_local: "AR-02",area_planta: 100,area_mezanina: 0,area_terraza: 0,mall_id: 1,nivel_mall_id: 1,tipo_local_id: nil,tipo_estado_local: 1})
    assert_not local.valid?, "Error: El local  debe estar asociado a un tipo de local"
  end
  test "el local  debe tener nro unico en el mismo mall" do
    local = Local.create({nro_local: "AR-01",area_planta: 100,area_mezanina: 0,area_terraza: 0,mall_id: 1,nivel_mall_id: 1,tipo_local_id: 0,tipo_estado_local: 1})
    assert_not local.valid?, "Error: El local  no cumple con nro único en el mismo mall"
  end
  test "el local  puedee tener numero igual en diferentes malls" do
    local = Local.create({nro_local: "AR-01",area_planta: 100,area_mezanina: 0,area_terraza: 0,mall_id: 2,nivel_mall_id: 1,tipo_local_id: 0,tipo_estado_local: 1})
    assert local.valid?, "Error: El local  no cumple con nro igual en diferentes malls"
  end
  test "eliminar local" do
    local = locals(:ar03).destroy
    assert_equal(local.nro_local,"AR-03","Error: No permite eliminar el local ")
  end
  test "eliminar local asociado" do
    local = locals(:ar01).destroy
    assert_equal(false,local,"Error: El local  no puede eliminarse con tiendas asociados")
  end

end

