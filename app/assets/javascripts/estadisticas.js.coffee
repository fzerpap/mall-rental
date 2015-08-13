#= require dataTables/jquery.dataTables.js
#= require dataTables/dataTables.bootstrap.js
#= require dataTables/dataTables.responsive.js
#= require dataTables/dataTables.tableTools.min.js
#= require jqGrid/i18n/grid.locale-el.js
#= require jqGrid/jquery.jqGrid.min.js
#= require jquery-ui/jquery-ui.min.js
#= require datapicker/bootstrap-datepicker.js
#= require iCheck/icheck.min.js

jQuery(document).ready ($) ->
  datatable_estadisticas()

  $('#fecha_init').datepicker
    keyboardNavigation: false
    forceParse: false
    autoclose: true
    format: 'dd/mm/yyyy'
    language: 'es'

  $('#fecha_end').datepicker
    keyboardNavigation: false
    forceParse: false
    autoclose: true
    format: 'dd/mm/yyyy'
    language: 'es'

  $('#mista_onetake_button').click ->
    $('#table_intermensuales').empty()
    $('#loading_intermensuales').show()
    $.ajax
      type: "POST"
      url: "/estadisticas/intermensuales"
      dataType: "HTML"
      data:
        fecha_init: $('#fecha_init').val()
        fecha_end: $('#fecha_end').val()
        nivel_mall_id: $('#nivel_mall_select_tiendas').val()
        actividad_economica_id: $('#actividad_economica_select_tiendas').val()
        tipo_local_id: $('#tipo_local_select_tiendas').val()
        criterio: $('#criterio').val()
      success: (data) ->
        html = $('#table_intermensuales')
        html.empty()
        html.append(data)
        datatable_estadisticas()
      complete: ->
        $('#loading_intermensuales').hide()


  $('#mensuales_ano_select').change ->
    $('#table_mensuales').empty()
    $('#loading_intermensuales').show()
    $.ajax
      type: "POST"
      url: "/estadisticas/mensuales"
      dataType: "HTML"
      data:
        year: $('#mensuales_ano_select').val()
      success: (data) ->
        html = $('#table_mensuales')
        html.empty()
        html.append(data)
        datatable_estadisticas()
      complete: ->
        $('#loading_intermensuales').hide()


datatable_estadisticas =  ->
  $('.datatable_estadisticas').dataTable
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