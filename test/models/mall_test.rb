require 'test_helper'

class MallTest < ActiveSupport::TestCase
  test "el mall debe tener valores" do
    mall = Mall.create()
    assert_not mall.valid?, "Error: El mall no tiene valores"
  end
  test "el mall tiene todos los valores" do
    mall = Mall.create({nombre: "Centro Comercial Prueba",abreviado: "C.C Prueba",rif: "J-315567-1",direccion_fiscal: "Mérida",telefono: "0274-234567",pai_id: 1})
    assert mall.valid?, "Error: El mall tiene todos los valores"
  end
  test "el mall debe tener nombre" do
    mall = Mall.create({nombre: "",abreviado: "C.C Prueba",rif: "J-315567-1",direccion_fiscal: "Mérida",telefono: "0274-234567",pai_id: 1})
    assert_not mall.valid?, "Error: El mall no tiene nombre"
  end
  test "el mall debe tener abreviado" do
    mall = Mall.create({nombre: "Centro Comercial Prueba",abreviado: "",rif: "J-315567-1",direccion_fiscal: "Mérida",telefono: "0274-234567",pai_id: 1})
    assert_not mall.valid?, "Error: El mall no tiene abreviado"
  end
  test "el mall debe tener rif" do
    mall = Mall.create({nombre: "Centro Comercial Prueba",abreviado: "C.C Prueba",rif: "",direccion_fiscal: "Mérida",telefono: "0274-234567",pai_id: 1})
    assert_not mall.valid?, "Error: El mall no tiene RIF"
  end
  test "el mall debe tener dirección" do
    mall = Mall.create({nombre: "Centro Comercial Prueba",abreviado: "C.C Prueba",rif: "J-315567-1",direccion_fiscal: "",telefono: "0274-234567",pai_id: 1})
    assert_not mall.valid?, "Error: El mall no tiene dirección fiscal"
  end
  test "el mall debe tener telefono" do
    mall = Mall.create({nombre: "Centro Comercial Prueba",abreviado: "C.C Prueba",rif: "J-315567-1",direccion_fiscal: "Mérida",telefono: "",pai_id: 1})
    assert_not mall.valid?, "Error: El mall no tiene teléfonos"
  end
  test "el mall debe estar asociado a un pais" do
    mall = Mall.create({nombre: "Centro Comercial Prueba",abreviado: "C.C Prueba",rif: "J-315567-1",direccion_fiscal: "Mérida",telefono: "0274-234567"})
    assert_not mall.valid?, "Error: El mall debe estar asociado a un país"
  end
  test "el mall debe tener nombre unico" do
    mall = Mall.create({nombre: "Centro Comercial la Vela",abreviado: "C.C Prueba",rif: "J-315567-1",direccion_fiscal: "Mérida",telefono: "0274-234567",pai_id: 1})
    assert_not mall.valid?, "Error: El mall no cumple con nombre único"
  end
  test "el mall debe tener abreviado unico" do
    mall = Mall.create({nombre: "Centro Comercial Prueba",abreviado: "C.C la Vela",rif: "J-315567-1",direccion_fiscal: "Mérida",telefono: "0274-234567",pai_id: 1})
    assert_not mall.valid?, "Error: El mall no cumple con abreviado único"
  end
  test "el mall debe tener rif unico" do
    mall = Mall.create({nombre: "Centro Comercial Prueba",abreviado: "C.C Prueba",rif: "J-31665087-1",direccion_fiscal: "Mérida",telefono: "0274-234567",pai_id: 1})
    assert_not mall.valid?, "Error: El mall no cumple con RIF único"
  end


end

