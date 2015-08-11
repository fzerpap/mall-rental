#= require input-mask/jquery.inputmask.js
#= require input-mask/jquery.inputmask.regex.extensions.js
#= require jasny/jasny-bootstrap
#= require dataTables/jquery.dataTables.js
#= require dataTables/dataTables.bootstrap.js
#= require dataTables/dataTables.responsive.js
#= require dataTables/dataTables.tableTools.min.js
#= require jqGrid/i18n/grid.locale-el.js
#= require jqGrid/jquery.jqGrid.min.js
#= require jquery-ui/jquery-ui.min.js
#= require bootstrapValidator/bootstrapValidator
#= require jquery.blockUI.js
#= require numeric
#= require jquery.number.js

jQuery(document).ready ($) ->

  table_index_datatable()

  $('#form_tiendas').bootstrapValidator
    feedbackIcons:
      valid: 'fa fa-check ',
      invalid: 'fa fa-times',
      validating: 'fa fa-refresh'
    live: 'enabled'
    fields:
      "tienda[local_id]":
        validators:
          notEmpty:
            message: "El local es obligatorio"
      "tienda[arrendatario_id]":
        validators:
          notEmpty:
            message: "El arrendatario es obligatorio"
      "tienda[actividad_economica_id]":
        validators:
          notEmpty:
            message: "La actividad económica es obligatoria"
      "tienda[monto_garantia]":
        validators:
          notEmpty:
            message: "El monto del depósito de garantía es obligatorio"
      tipo_canon_alquiler_required:
        selector: '.tipo_canon_alquiler_required'
        validators:
          notEmpty:
            message: "El tipo de canon de alquiler es obligatorio"
      canon_fijo_ml:
        selector: '.canon_fijo_ml'
        validators:
          numeric:
            message: 'Debe ser un valor numerico, decimales separados por punto'
          callback:
            message: 'Canon fijo en moneda local obligatorio'
            callback: (value, validator, $field) ->
              canon = $('#select_canon_alquiler').val()
              if (canon == '1' or canon == '4' or canon == '5') and (value == '' || value == '0.0')
                false
              else
                true
      porc_canon_ventas:
        selector: '.porc_canon_ventas'
        validators:
          numeric:
            message: 'Debe ser un valor numérico, decimales separados por punto'
          callback:
            message: '% Canón por ventas es obligatorio'
            callback: (value, validator, $field) ->
              canon = $('#select_canon_alquiler').val()
              if (canon == '2' or canon == '3' or canon == '4' or canon == '5') and (value == '' || value == '0.0')
                false
              else
                true

  $('#add_actividad_economica_select').hide()
  $('#validacion_nombre_actividad').hide()
  $('#validacion_nombre_en_uso_actividad').hide()
  $('#loading_actividad_economica').hide()

  $('#select_actividad_economica_tienda').change ->
    $('#validacion_nombre_en_uso_actividad').hide()
    $('#validacion_nombre_actividad').hide()
    if $(this).val() == 'nueva_actividad_economica'
      $('#add_actividad_economica_select').show()
    else
      $('#add_actividad_economica_select').hide()


  $('#tienda_arrendatario_id').change ->
    if $('#tienda_nombre').val() == '' && $(this).val() != ''
      $('#tienda_nombre').val($('#tienda_arrendatario_id option:selected').text())

  $('#agregar_actividad_economica_tienda').click ->
    if $('#nueva_actividad_economica').val() == ''
      $('#validacion_nombre_actividad').show()
    else
      $('#loading_actividad_economica').show()
      $.ajax
        type: "POST"
        url: "/dynamic_add_actividad/actividad"
        dataType: "JSON"
        data:
          nombre: $('#nueva_actividad_economica').val()
        success: (data) ->
          $('#validacion_nombre_en_uso_actividad').hide()
          $('#select_actividad_economica_tienda')
          .append($('<option>', { value : data.id })
            .text(data.nombre));
          $("#select_actividad_economica_tienda").val(data.id);
          $('#add_actividad_economica_select').hide()
          $('#nueva_actividad_economica').val('')
          $.blockUI({
            message: $('div.growlUI'),
            fadeIn: 700,
            fadeOut: 700,
            timeout: 3000,
            showOverlay: false,
            centerY: false,
            css: {
              width: '350px',
              top: '40px',
              left: '',
              right: '10px',
              border: 'none',
              padding: '5px',
              backgroundColor: '#000',
              '-webkit-border-radius': '10px',
              '-moz-border-radius': '10px',
              opacity: .6,
              color: '#fff'
            }
          });
        error: (data)->
          $('#validacion_nombre_en_uso_actividad').show()
        complete: ->
          $('#loading_actividad_economica').hide()

  $('#select_canon_alquiler').change ->
    if $(this).val() == '1'
      $('#canon_fijo').show()
      $('#canon_fijo').find(':input').prop('disabled', false);
      $('#canon_porcentaje').hide()
      $('#canon_porcentaje').find(':input').prop('disabled', true);
      $('#requerida_venta_check').prop('disabled', false).prop('checked', true);
    else if ($(this).val() == '4' || $(this).val() == '5')
      $('#canon_fijo').show()
      $('#canon_fijo').find(':input').prop('disabled', false);
      $('#canon_porcentaje').show()
      $('#canon_porcentaje').find(':input').prop('disabled', false);
      $('#requerida_venta_check').prop('disabled', true).prop('checked', true);
      calcular_monto_minimo_venta()
    else if ($(this).val() == '2' || $(this).val() == '3')
      $('#canon_fijo').hide()
      $('#canon_fijo').find(':input').prop('disabled', true);
      $('#canon_porcentaje').show()
      $('#canon_porcentaje').find(':input').prop('disabled', false);
      $('#monto_minimo_tienda').val('0')
      $('#requerida_venta_check').prop('disabled', true).prop('checked', true);
      key_up_porc_venta()
    else
      $('#canon_fijo').hide()
      $('#canon_fijo').find(':input').prop('disabled', true);
      $('#canon_porcentaje').hide()
      $('#canon_porcentaje').find(':input').prop('disabled', true);
      $('#requerida_venta_check').prop('disabled', true).prop('checked', false);

  $('.tienda-filter').change ->
    $('#div_table_tiendas_index').empty()
    $('#loading_table_index').show()
    $.ajax
      type: "POST"
      url: "/tiendas/mf_dynamic_filter/"
      dataType: "HTML"
      data:
        nivel_mall_id: $('#nivel_mall_select_tiendas').val()
        actividad_economica_id: $('#actividad_economica_select_tiendas').val()
        vencido: $('#contratos_select_tiendas').val()
      success: (data) ->
        html = $('#div_table_tiendas_index')
        html.empty()
        html.append(data)
        $('#loading_table_index').hide()
        table_index_datatable()
      complete: ->
        $('#loading_table_index').hide()

  $('.canon_fijo_ml').keyup ->
    $.ajax
      type: "POST"
      url: "/cambio_monedas/mf_cambio_moneda/"
      dataType: "JSON"
      data:
        ml: $(this).val()
      success: (data) ->
        $('.canon_fijo_usd').val(data.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"))

  $("#porc_canon_tienda").inputmask("Regex", {
    regex: "[0-9.]{1,25}"
  });


  $('#canon_fijo_tienda').inputmask("Regex", {
    regex: "[0-9.]{1,25}"
  });

  $('#tienda_monto_garantia').inputmask("Regex", {
    regex: "[0-9.]{1,25}"
  });


 # $(".campo_numerico").number(true,2,',','.')


  $('#tienda_monto_garantia').keyup ->
    $.ajax
      type: "POST"
      url: "/cambio_monedas/mf_cambio_moneda/"
      dataType: "JSON"
      data:
        ml: $(this).val()
      success: (data) ->
        $('#tienda_monto_garantia_usd').val(data.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"))

table_index_datatable =  ->
  $('#table_tiendas_index').dataTable
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
calcular_monto_minimo_venta = ->
  $('#porc_canon_tienda').keyup ->
    if $(this).val() > 100
      $(this).val 100
    if $(this).val() == ''
      value = 0
    else
      value = $('#canon_fijo_tienda').val().replace(',', '')/($(this).val()/100)
    $('#monto_minimo_tienda').val value.toFixed(2)

  $('#canon_fijo_tienda').keyup ->
    if $('#porc_canon_tienda').val() == ''
      value = 0
    else
      value = $(this).val().replace(',', '')/($('#porc_canon_tienda').val()/100)
      $('#monto_minimo_tienda').val value.toFixed(2)

key_up_porc_venta = ->
  $('#porc_canon_tienda').keyup ->
    if $(this).val() > 100
      $(this).val 100
    $('#monto_minimo_tienda').val 0