require 'test_helper'

class NivelnivelTest < ActiveSupport::TestCase
  test "el nivel debe tener valores" do
    nivel = NivelMall.create()
    assert_not nivel.valid?, "Error: El nivel no tiene valores"
  end
  test "el nivel tiene todos los valores" do
    nivel = NivelMall.create({nombre: "Nivel Sol",mall_id: 1})
    assert nivel.valid?, "Error: El nivel tiene todos los valores"
  end
  test "el nivel debe tener nombre" do
    nivel = NivelMall.create({nombre: "",mall_id: 1})
    assert_not nivel.valid?, "Error: El nivel no tiene nombre"
  end
  test "el nivel debe estar asociado a un mall" do
    nivel = NivelMall.create({nombre: "Nivel Sol",mall_id: nil})
    assert_not nivel.valid?, "Error: El nivel debe estar asociado a un mall"
  end
  test "el nivel debe tener nombre unico en el mismo mall" do
    nivel = NivelMall.create({nombre: "Nivel Arena",mall_id: 1})
    assert_not nivel.valid?, "Error: El nivel no cumple con nombre único en el mismo mall"
  end
  test "el nivel debe tener nombre igual en diferentes malls" do
    nivel = NivelMall.create({nombre: "Nivel Arena",mall_id: 2})
    assert nivel.valid?, "Error: El nivel no cumple con nombre igual en diferentes malls"
  end
  test "eliminar nivel" do
    nivel = nivel_malls(:oro).destroy
    assert_equal(nivel.nombre,"Nivel Oro","Error: No permite eliminar el nivel")
  end
  test "eliminar nivel asociado" do
    nivel = nivel_malls(:arena).destroy
    assert_equal(false,nivel,"Error: El nivel no puede eliminarse con locales asociados")
  end

end

