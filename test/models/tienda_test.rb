require 'test_helper'

class TiendaTest < ActiveSupport::TestCase
  # Pruebas de validaciones
  test "la tienda  debe tener valores" do
    tienda = Tienda.create()
    assert_not tienda.valid?, "Error: La tienda  no tiene valores"
  end
  test "la tienda  tiene todos los valores" do
    tienda = Tienda.create({nombre: "La Sensa",local_id: 1,actividad_economica_id: 1,arrendatario_id: 1,fecha_apertura: "2016-01-01".to_date,
                            fecha_fin_contrato_actual: "2016-12-31".to_date,monto_garantia: 200000,monto_garantia_usd: 200,codigo_contable: "1.1.1.14",abierta: true})
    assert tienda.valid?, "Error: La tienda tiene todos los valores"
  end
  test "la tienda  tiene nombre" do
    tienda = Tienda.create({nombre: "",local_id: 1,actividad_economica_id: 1,arrendatario_id: 1,fecha_apertura: "2016-01-01".to_date,
                            fecha_fin_contrato_actual: "2016-12-31".to_date,monto_garantia: 200000,monto_garantia_usd: 200,codigo_contable: "1.1.1.14",abierta: true})
    assert_not tienda.valid?, "Error: La tienda no tiene nombre"
  end
  test "la tienda  tiene local disponible" do
    tienda = Tienda.create({nombre: "La Sensa",local_id: 2,actividad_economica_id: 1,arrendatario_id: 1,fecha_apertura: "2016-01-01".to_date,
                            fecha_fin_contrato_actual: "2016-12-31".to_date,monto_garantia: 200000,monto_garantia_usd: 200,codigo_contable: "1.1.1.14",abierta: true})
    assert_not tienda.valid?, "Error: La tienda no tiene local disponbile"
  end
  test "la tienda  tiene local" do
    tienda = Tienda.create({nombre: "La Sensa",local_id: nil,actividad_economica_id: 1,arrendatario_id: 1,fecha_apertura: "2016-01-01".to_date,
                            fecha_fin_contrato_actual: "2016-12-31".to_date,monto_garantia: 200000,monto_garantia_usd: 200,codigo_contable: "1.1.1.14",abierta: true})
    assert_not tienda.valid?, "Error: La tienda no tiene local"
  end
  test "la tienda  tiene actividad" do
    tienda = Tienda.create({nombre: "La Sensa",local_id: 1,actividad_economica_id: nil,arrendatario_id: 1,fecha_apertura: "2016-01-01".to_date,
                            fecha_fin_contrato_actual: "2016-12-31".to_date,monto_garantia: 200000,monto_garantia_usd: 200,codigo_contable: "1.1.1.14",abierta: true})
    assert_not tienda.valid?, "Error: La tienda no tiene actividad económica"
  end
  test "la tienda  tiene arrendatario" do
    tienda = Tienda.create({nombre: "La Sensa",local_id: 1,actividad_economica_id: 1,arrendatario_id: nil,fecha_apertura: "2016-01-01".to_date,
                            fecha_fin_contrato_actual: "2016-12-31".to_date,monto_garantia: 200000,monto_garantia_usd: 200,codigo_contable: "1.1.1.14",abierta: true})
    assert_not tienda.valid?, "Error: La tienda no tiene arrendatario"
  end
  test "la tienda  tiene fecha de apertura" do
    tienda = Tienda.create({nombre: "La Sensa",local_id: 1,actividad_economica_id: 1,arrendatario_id: 1,fecha_apertura: nil,
                            fecha_fin_contrato_actual: "2016-12-31".to_date,monto_garantia: 200000,monto_garantia_usd: 200,codigo_contable: "1.1.1.14",abierta: true})
    assert_not tienda.valid?, "Error: La tienda no tiene fecha de apertura"
  end
  test "la tienda  tiene fecha fin de contrato actual" do
    tienda = Tienda.create({nombre: "La Sensa",local_id: 1,actividad_economica_id: 1,arrendatario_id: 1,fecha_apertura: "2016-01-01".to_date,
                            fecha_fin_contrato_actual: nil,monto_garantia: 200000,monto_garantia_usd: 200,codigo_contable: "1.1.1.14",abierta: true})
    assert_not tienda.valid?, "Error: La no tienda fecha de fin de contrato actual"
  end
  test "eliminar tienda" do
    tienda = tiendas(:tomy).destroy
    assert_equal(tienda.nombre,"Tomy","Error: No permite eliminar la tienda ")
  end
  test "eliminar tienda asociada" do
    tienda = tiendas(:adidas).destroy
    assert_equal(false,tienda,"Error: La tienda no puede eliminarse con contratos de alquiler asociados")
  end

  # Pruebas de métodos
  test "vencimiento del contrato" do
    vencido = tiendas(:adidas).vencido?
    assert_equal("No",vencido,"Error: El contrato de la tienda no puede estar vencido")
  end

  test "tiendas del mall 1 abiertas" do
    tiendas = Tienda.get_ids_tiendas_mall(malls(:vela))
    assert_equal([1],tiendas,"Error: Las tiendas del mall 1 abiertas son incorrectas")
  end
  test "tiendas del mall 2 abiertas" do
    tiendas = Tienda.get_ids_tiendas_mall(malls(:orinokia))
    assert_equal([3,2],tiendas,"Error: Las tiendas del mall 2 abiertas son incorrectas")
  end
  test "tiendas del mall 2 cerradas" do
    tiendas = Tienda.get_ids_tiendas_mall(malls(:orinokia),false)
    assert_equal([],tiendas,"Error: Las tiendas del mall 2 cerradas son incorrectas")
  end
end

