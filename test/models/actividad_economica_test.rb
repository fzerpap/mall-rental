require 'test_helper'

class ActividadEconomicaTest < ActiveSupport::TestCase
  test "la actividad economica debe tener valores" do
    actividad ActividadEconomica.create()
    assert_not actividad.valid?, "Error: La actividad economica no tiene valores"
  end
  test "la actividad economica tiene todos los valores" do
    actividad ActividadEconomica.create({nombre: "Ropa",mall_id: 1})
    assert actividad.valid?, "Error: La actividad economica tiene todos los valores"
  end
  test "la actividad economica debe tener nombre" do
    actividad ActividadEconomica.create({nombre: "",mall_id: 1})
    assert_not actividad.valid?, "Error: La actividad economica no tiene nombre"
  end
  test "la actividad economica debe estar asociado a un mall" do
    actividad ActividadEconomica.create({nombre: "Ropa",mall_id: nil})
    assert_not actividad.valid?, "Error: La actividad economica debe estar asociado a un mall"
  end
  test "la actividad economica debe tener nombre unico en el mismo mall" do
    actividad ActividadEconomica.create({nombre: "Calzado",mall_id: 1})
    assert_not actividad.valid?, "Error: La actividad economica no cumple con nombre único en el mismo mall"
  end
  test "la actividad economica debe tener nombre igual en diferentes malls" do
    actividad ActividadEconomica.create({nombre: "Calzado",mall_id: 2})
    assert actividad.valid?, "Error: La actividad economica no cumple con nombre igual en diferentes malls"
  end
  test "eliminar actividad" do
    actividad = actividad_economicas(:bancos).destroy
    assert_equal(actividad.nombre,"Bancos","Error: No permite eliminar la actividad economica")
  end
  test "eliminar nivel asociado" do
    actividad = actividad_economicas(:calzado).destroy
    assert_equal(false,actividad,"Error: La actividad economica no puede eliminarse con tiendas asociados")
  end

end

