#= require bootstrapValidator/bootstrapValidator.js
#= require jasny/jasny-bootstrap.min
#= require jquery.blockUI.js
#= require dataTables/jquery.dataTables.js
#= require dataTables/dataTables.bootstrap.js
#= require dataTables/dataTables.responsive.js
#= require dataTables/dataTables.tableTools.min.js

jQuery(document).ready ->
  table_index_datatable()
  $('#form_registro_local').bootstrapValidator
    feedbackIcons:
      valid: 'fa fa-check ',
      invalid: 'fa fa-times',
      validating: 'fa fa-refresh'
    live: 'submitted'
    fields:
      "local[nro_local]":
        validators:
          notEmpty:
            message: 'El n° de local es obligatorio'
      "local[area_planta]":
        validators:
          notEmpty:
            message: 'El área de planta es obligatoria'
          numeric:
            message: 'Debe ser numérico'
      "local[area_terraza]":
        validators:
          notEmpty:
            message: 'El área de la terraza es obligatoria'
        numeric:
          message: 'Debe ser numérico'
      "local[area_mezanina]":
        validators:
          notEmpty:
            message: 'El àrea de la mezanina es obligatoria'
          numeric:
            message: 'Debe ser numérico'
      "local[nivel_mall_id]":
        validators:
          notEmpty:
            message: 'El nivel de ubicación es obligatorio'
      "local[tipo_local_id]":
        validators:
          notEmpty:
            message: 'El tipo de local es obligatorio'
          numeric:
            message: 'El tipo de local es necesario guardarlo'
      "local[tipo_estado_local]":
        validators:
          notEmpty:
            message: 'El estado del local es obligatorio'


  $('#form_edit_local').bootstrapValidator
    feedbackIcons:
      valid: 'fa fa-check ',
      invalid: 'fa fa-times',
      validating: 'fa fa-refresh'
    live: 'submitted'
    fields:
      "local[nro_local]":
        validators:
          notEmpty:
            message: 'El n° de local es obligatorio'
      "local[area_planta]":
        validators:
          notEmpty:
            message: 'El área de planta es obligatoria'
          numeric:
            message: 'Debe ser numérico'
      "local[area_terraza]":
        validators:
          notEmpty:
            message: 'El área de la terraza es obligatoria'
        numeric:
          message: 'Debe ser numérico'
      "local[area_mezanina]":
        validators:
          notEmpty:
            message: 'El àrea de la mezanina es obligatoria'
          numeric:
            message: 'Debe ser numérico'
      "local[nivel_mall_id]":
        validators:
          notEmpty:
            message: 'El nivel de ubicación es obligatorio'
      "local[tipo_local_id]":
        validators:
          notEmpty:
            message: 'El tipo de local es obligatorio'
      "local[tipo_estado_local]":
        validators:
          notEmpty:
            message: 'El estado del local es obligatorio'


$("#local_nivel_mall_id").on "change", ->
  if (this.value) == '-1'
    $(".mostrar").css "display","none"
    $(".oculto").css "display","block"
    $("#validacion_nombre_nivel").css "display","none"
    $("#validacion_nombre_en_uso_nivel").css "display","none"
$("#icon-deshacer-new-nivel").on "click", ->
  $(".mostrar").css "display","block"
  $(".oculto").css "display","none"
  $("#validacion_nombre_nivel").css "display","none"
  $("#validacion_nombre_en_uso_nivel").css "display","none"
  $("#local_nivel_mall_id").val('')
  $("#nivel_mall_new").val('')

$("#icon-save-new-nivel").on "click", ->
  valor = $("#nivel_mall_new").val()
  if(valor != '')
    $("#validacion_nombre_nivel").css "display","none"
    if confirm("Esta seguro de guardar el nuevo Nivel Mall")
      $.ajax
        type: "POST"
        url: "/dynamic_add_nivel_mall/guardar"
        dataType: "JSON"
        async: false
        data:
          nombre: valor
        success: (data) ->

          $("#local_nivel_mall_id").append("<option value='"+data.id+"'>"+data.nombre+"</option>")
          $("#local_nivel_mall_id").val(data.id)
          $(".mostrar").css "display","block"
          $(".oculto").css "display","none"
          $.blockUI({
            message: 'Ubicacion Nivel fue guardado exitosamente',
            timeout: 2000,
          });
        error: (data)->
          $("#validacion_nombre_en_uso_nivel").css "display","block"
          console.log(data)
        complete: ->
          a=1
  else
    $("#validacion_nombre_nivel").css "display","block"

  $("#nivel_mall_new").on "focus", ->
    $("#validacion_nombre_en_uso_nivel").css "display","none"
    $("#validacion_nombre_nivel").css "display","none"

$(".filtro_local").on "change", ->
  tipo = $("#tipo_local_id").val()
  ubicacion = $("#ubicacion_id").val()
  estado = $("#tipo_estado_local_tipo").val()
  $('#div_table_locals_index').empty()
  $('#loading_table_index').show()
  $.ajax
    type: "POST"
    url: "/dynamic_filter_locals/actualizar"
    dataType: "HTML"
    async: false
    data:
      tipo: tipo
      ubicacion: ubicacion
      estado: estado
    success: (data) ->
      html = $('#div_table_locals_index')
      html.empty()
      html.append(data)
      $('#loading_table_index').hide()
    error: (data)->
      console.log(data)
    complete: ->
      $('#loading_table_index').hide()


table_index_datatable =  ->
  $('#table_locals_index').dataTable
    'dom': 'T<"clear">lfrtip'
    'tableTools':
      'sSwfPath': '../assets/dataTables/swf/copy_csv_xls_pdf.swf'
      "aButtons": [
        {
          "sExtends":     "copy",
          "sButtonText": 'Copiar &nbsp; <i class="fa fa-files-o"></i>'
        },
        {
          "sExtends":     "csv",
          "sButtonText": 'Excel &nbsp; <i class="fa fa-file-excel-o"></i>'
        },
        {
          "sExtends":     "pdf",
          "sButtonText": 'PDF &nbsp; <i class="fa fa-file-pdf-o"></i>'
        },
        {
          "sExtends":     "print",
          "sButtonText": 'Imprimir &nbsp; <i class="fa fa-print"></i>'
        },
      ]
    "language": {
      "sProcessing":    'Procesando... <i class="fa fa-spinner fa-spin"></i>',
      "sLengthMenu":    "Mostrar _MENU_ Registros",
      "sZeroRecords":   "No se encontraron resultados",
      "sEmptyTable":    "Ningún dato disponible en esta tabla",
      "sInfo":          "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
      "sInfoEmpty":     "Mostrando registros del 0 al 0 de un total de 0 registros",
      "sInfoFiltered":  "(filtrado de un total de _MAX_ registros)",
      "sInfoPostFix":   "",
      "sSearch":        '<i class="fa fa-search"></i> Buscar: ',
      "sUrl":           "",
      "sInfoThousands":  ",",
      "sLoadingRecords": 'Cargando... <i class="fa fa-spinner fa-spin"></i>',
      "oPaginate": {
        "sFirst":    "Primero",
        "sLast":    "Último",
        "sNext":    'Siguiente <i class="fa fa-angle-right"></i>',
        "sPrevious": '<i class="fa fa-angle-left"></i> Anterior'
      },
      "oAria": {
        "sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
        "sSortDescending": ": Activar para ordenar la columna de manera descendente"
      }
    }
