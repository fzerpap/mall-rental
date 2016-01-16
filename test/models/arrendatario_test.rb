require 'test_helper'

class ArrendatarioTest < ActiveSupport::TestCase
  test "el arrendatario  debe tener valores" do
    arrendatario = Arrendatario.create()
    assert_not arrendatario.valid?, "Error: El arrendatario  no tiene valores"
  end
  test "el arrendatario  tiene todos los valores" do
    arrendatario = Arrendatario.create({nombre: "La Sensa",rif: "J-3166578-1",direccion: "Av. urdantena",telefono: "0275-456787",nombre_rl: "Juan Parra",cedula_rl: "10.109.234",email_rl: "jparra@gmail.com",telefono_rl: "0416-678877",mall_id: 1,registro_mercantil: "rm.."})
    assert arrendatario.valid?, "Error: El arrendatario  tiene todos los valores"
  end
  test "el arrendatario  debe tener nombre" do
    arrendatario = Arrendatario.create({nombre: "",rif: "J-3166578-1",direccion: "Av. urdantena",telefono: "0275-456787",nombre_rl: "Juan Parra",cedula_rl: "10.109.234",email_rl: "jparra@gmail.com",telefono_rl: "0416-678877",mall_id: 1,registro_mercantil: "rm.."})
    assert_not arrendatario.valid?, "Error: El arrendatario  no tiene nombre"
  end
  test "el arrendatario  debe tener rif" do
    arrendatario = Arrendatario.create({nombre: "",rif: "",direccion: "Av. urdantena",telefono: "0275-456787",nombre_rl: "Juan Parra",cedula_rl: "10.109.234",email_rl: "jparra@gmail.com",telefono_rl: "0416-678877",mall_id: 1,registro_mercantil: "rm.."})
    assert_not arrendatario.valid?, "Error: El arrendatario  no tiene rif"
  end
  test "el arrendatario  debe tener nombre de rl" do
    arrendatario = Arrendatario.create({nombre: "",rif: "J-3166578-1",direccion: "Av. urdantena",telefono: "0275-456787",nombre_rl: "",cedula_rl: "10.109.234",email_rl: "jparra@gmail.com",telefono_rl: "0416-678877",mall_id: 1,registro_mercantil: "rm.."})
    assert_not arrendatario.valid?, "Error: El arrendatario  no tiene nombre de representante legal"
  end
  test "el arrendatario  debe tener un email de rl" do
    arrendatario = Arrendatario.create({nombre: "",rif: "J-3166578-1",direccion: "Av. urdantena",telefono: "0275-456787",nombre_rl: "Juan Parra",cedula_rl: "10.109.234",email_rl: "",telefono_rl: "0416-678877",mall_id: 1,registro_mercantil: "rm.."})
    assert_not arrendatario.valid?, "Error: El arrendatario  no tiene email de representante legal"
  end
  test "el arrendatario  debe estar asociado a un mall" do
    arrendatario = Arrendatario.create({nombre: "La Sensa",rif: "J-3166578-1",direccion: "Av. urdantena",telefono: "0275-456787",nombre_rl: "Juan Parra",cedula_rl: "10.109.234",email_rl: "jparra@gmail.com",telefono_rl: "0416-678877",mall_id: nil,registro_mercantil: "rm.."})
    assert_not arrendatario.valid?, "Error: El arrendatario  debe estar asociado a un mall"
  end
  test "el arrendatario  debe tener nombre unico en el mismo mall" do
    arrendatario = Arrendatario.create({nombre: "Adidas Vzla c.a",rif: "J-3166578-1",direccion: "Av. urdantena",telefono: "0275-456787",nombre_rl: "Juan Parra",cedula_rl: "10.109.234",email_rl: "jparra@gmail.com",telefono_rl: "0416-678877",mall_id: 1,registro_mercantil: "rm.."})
    assert_not arrendatario.valid?, "Error: El arrendatario  no cumple con nombre único en el mismo mall"
  end
  test "el arrendatario  puedee tener nombre igual en diferentes malls" do
    arrendatario = Arrendatario.create({nombre: "Adidas Vzla c.a",rif: "J-3166578-1",direccion: "Av. urdantena",telefono: "0275-456787",nombre_rl: "Juan Parra",cedula_rl: "10.109.234",email_rl: "jparra@gmail.com",telefono_rl: "0416-678877",mall_id: 2,registro_mercantil: "rm.."})
    assert arrendatario.valid?, "Error: El arrendatario  no cumple con nombreigual en diferentes malls"
  end
  test "eliminar arrendatario" do
    arrendatario = arrendatarios(:clark).destroy
    assert_equal(arrendatario.nombre,"Clark Vzla c.a","Error: No permite eliminar el arrendatario ")
  end
  test "eliminar arrendatario asociado" do
    arrendatario = arrendatarios(:adidas).destroy
    assert_equal(false,arrendatario,"Error: El arrendatario  no puede eliminarse con tiendas asociados")
  end

end

