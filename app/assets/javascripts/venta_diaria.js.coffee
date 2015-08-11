# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require jquery.blockUI.js
#= require jquery.number.js
#= require jquery-ui/jquery-ui.min.js

jQuery(document).ready ($) ->
  $(".actualizar_ventas").change()
  $(".actualizar_auditoria_ventas").change()
  $(".actualizar_ventas_mes").change()


$(".actualizar_ventas").on "change", ->
  $.ajax
    type: "POST"
    url: "/dynamic_venta_diaria/venta"
    dataType: "JSON"
    data:
      year: $("#date_lapso_year").val()
      month: $("#venta_diaria_select_month").val()
      tienda_id: $("#tienda_id").val()
    before_send: $.blockUI({message: 'Por favor espere...'})
    success: (data) ->
      suma = data[0]['suma']
      $("#total_ventas").val(suma)
      $("#total_ventas").number(true,2,',','.')
      $("#tbody_venta_bruta").empty()
      @dias_no_lab = data[0]['dias_no_lab']
      @cantidad_ventas_mes = data[0]['cantidad_ventas_mes']
      @dias_mes = data[0]['dias_mes']
      @total_cant_ventas = @dias_mes - (@dias_no_lab + @cantidad_ventas_mes)
      $("#tbody_venta_bruta").empty()
      $("#tbody_venta_neta").empty()
      for element, index in data[0]['ventas']
        @editable = element.editable
        if @editable
          @clase = 'editar_monto_venta'
          @title = 'Editar Monto'
          @clase_2 = 'editar_monto_notas_credito'
          @clase_3 = 'editar_costo_venta'
        else
          @clase = ''
          @clase_2 = ''
          @clase_3 = ''
          @title = 'Campo no editable'

        if element.id == -1
          @opcion = 'new'
        else
          @opcion = 'update'

        if @total_cant_ventas == 0 && !data[0]['mes_actual']
          $("#btn_up_documento_venta").prop('disabled', false);

        $("#tbody_venta_bruta").append("<tr><td>"+element.fecha+"</td><td id='mount_"+element.dia+"' class='"+@clase+"' identificador='"+element.id+"'  opcion='"+@opcion+"' title='"+@title+"' fecha='"+element.fecha+"' campo='"+element.dia+"' valor='"+element.monto+"'>"+element.monto+"</td><td id='nota_credito_"+element.dia+"' class='"+@clase_2+"' opcion='"+@opcion+"' identificador='"+element.id+"' title='"+@title+"' fecha='"+element.fecha+"' campo='"+element.dia+"' valor='"+element.monto_notas_credito+"'>"+element.monto_notas_credito+"</td><td id='venta_bruta_"+element.dia+"' class='clase_total' campo='"+element.dia+"' valor='"+element.monto_venta_bruta+"'>"+element.monto_venta_bruta+"</td></tr>")
        $("#tbody_venta_neta").append("<tr><td>"+element.fecha+"</td><td id='mount_"+element.dia+"' class='"+@clase+"' identificador='"+element.id+"' opcion='"+@opcion+"' title='"+@title+"' fecha='"+element.fecha+"' campo='"+element.dia+"' valor='"+element.monto+"'>"+element.monto+"</td><td id='nota_credito_"+element.dia+"' class='"+@clase_2+"' opcion='"+@opcion+"' identificador='"+element.id+"' title='"+@title+"' fecha='"+element.fecha+"' campo='"+element.dia+"' valor='"+element.monto_notas_credito+"'>"+element.monto_notas_credito+"</td><td id='venta_bruta_"+element.dia+"' class='clase_total' campo='"+element.dia+"' valor='"+element.monto_venta_bruta+"'>"+element.monto_venta_bruta+"</td><td id='costo_venta_"+element.dia+"' opcion='"+@opcion+"' campo='"+element.dia+"' class='"+@clase_3+"' identificador='"+element.id+"' valor='"+element.monto_costo_venta+"' >"+element.monto_costo_venta+"</td><td id='venta_neta_"+element.dia+"' class='clase_total' valor='"+element.monto_venta_neta+"' campo='"+element.dia+"'>"+element.monto_venta_neta+"</td></tr>")

        if !element.no_laborable
          $('#mount_'+element.dia).number(element.monto,2,',','.')
        $('#nota_credito_'+element.dia).number(element.monto_notas_credito,2,',','.')
        $('#venta_bruta_'+element.dia).number(element.monto_venta_bruta,2,',','.')
        $('#costo_venta_'+element.dia).number(element.monto_costo_venta,2,',','.')
        $('#venta_neta_'+element.dia).number(element.monto_venta_neta,2,',','.')

    error: (data)->
      console.log(data)
    complete: ->
      $.unblockUI()

$(".tbody_ventas_diarias").on
  click:->
    if $('input',this).length == 0
      valor = $(this).text()
      fecha = $(this).attr('fecha')
      id = $(this).attr('campo')
      $(this).text('')
      $(this).append("<input  type='text' value='"+valor+"' id='venta_"+id+"' valor='"+valor+"' codigo='"+fecha+"' campo='"+id+"'></input>")
      $('input',this).number(true,2,',','.')
      $('input',this).focus()
  ".editar_monto_venta"

$(".tbody_ventas_diarias").on
  click:->
    if $('input',this).length == 0
      valor = $(this).text()
      fecha = $(this).attr('fecha')
      id = $(this).attr('campo')
      $(this).text('')
      $(this).append("<input type='text' value='"+valor+"' valor='"+valor+"' codigo='"+fecha+"' campo='"+id+"'></input>")
      $('input',this).number(true,2,',','.')
      $('input',this).focus()
  ".editar_monto_notas_credito"

$(".tbody_ventas_diarias").on
  click:->
    if $('input',this).length == 0
      valor = $(this).text()
      id = $(this).attr('campo')
      $(this).text('')
      $(this).append("<input type='text' value='"+valor+"' valor='"+valor+"' id='costo_venta_"+id+"' campo='"+id+"'></input>")
      $('input',this).number(true,2,',','.')
      $('input',this).focus()

  ".editar_costo_venta"

$(".tbody_ventas_diarias").on
  blur:->
    if ($(this).val() != '')
      $(this).parent().attr('valor',$(this).val())
      $(this).parent().addClass('campo_editar')
      monto = $(this).number(true,2,',','.')
      $(this).parent().number(monto.val(),2,',','.')
      $(this).remove()
    else
      $(this).parent().text($(this).val())
      $(this).remove()
  ".editar_monto_venta input"

$(".tbody_ventas_diarias").on
  blur:->
    if ($(this).val() != '')
      $(this).parent().attr('valor',$(this).val())
      $(this).parent().addClass('campo_editar')
      monto = $(this).number(true,2,',','.')
      $(this).parent().number(monto.val(),2,',','.')
      $(this).remove()
    else
      $(this).parent().text($(this).val())
      $(this).remove()
  ".editar_monto_notas_credito input"

$(".tbody_ventas_diarias").on
  blur:->
    if ($(this).val() != '')
      $(this).parent().attr('valor',$(this).val())
      $(this).parent().addClass('campo_editar')
      monto = $(this).number(true,2,',','.')
      $(this).parent().number(monto.val(),2,',','.')
      $(this).remove()
    else
      $(this).parent().text($(this).val())
      $(this).remove()
  ".editar_costo_venta input"

$(".tbody_ventas_diarias").on
  keyup:->
    campo = $(this).attr('campo')
    nota_credito = $('#nota_credito_'+campo).attr('valor')

    if $(this).val() == '' && $(this).val() <= 0
      if $('#nota_credito_'+campo).text() == '' && $('#nota_credito_'+campo).text() <= 0
        value = 0
      else
        value = $('#nota_credito_'+campo).attr('valor')

    else if $(this).val() != ''
      if $('#nota_credito_'+campo).attr('valor') != ''
        nota_cred = $('#nota_credito_'+campo).attr('valor')
        nota_cred = parseFloat(nota_cred)
      else
        nota_cred = 0
      value = parseFloat($(this).val()) - nota_cred
    else
      value = parseFloat($(this).val()) - $('#nota_credito_'+campo).attr('valor')

    $('#venta_bruta_'+campo).attr('valor',value)
    $('#venta_bruta_'+campo).number(value,2,',','.')

  ".editar_monto_venta input"

$(".tbody_ventas_diarias").on
  keyup:->
    campo = $(this).attr('campo')
    if $(this).val() == '' && $(this).val() <= 0
      value = $('#mount_'+campo).attr('valor')
    else if $(this).val() != ''
      monto = $('#mount_'+campo).attr('valor')
      monto = parseFloat(monto)
      value = monto - parseFloat($(this).val())
    else
      value = $('#mount_'+campo).attr('valor')-($(this).val())
    $('#venta_bruta_'+campo).attr('valor',value)
    $('#venta_bruta_'+campo).number(value,2,',','.')
    if $('#costo_venta'+campo).text() == '' && $('#costo_venta'+campo).text() <= 0
      $('#venta_neta_'+campo).attr('valor',value)
      $('#venta_neta_'+campo).number(value,2,',','.')
    else
      value2 = value - $('#costo_venta'+campo).attr('valor')
      $('#venta_neta_'+campo).attr('valor',value2)
      $('#venta_neta_'+campo).number(value2,2,',','.')

  ".editar_monto_notas_credito input"

$(".tbody_ventas_diarias").on
  keyup:->
    campo = $(this).attr('campo')

    if $('#venta_bruta_'+campo).text() != ''
      venta_bruta = $('#venta_bruta_'+campo).attr('valor')
    if $(this).val() == '' && $(this).val() <= 0
      value = venta_bruta
    else if $(this).val() != ''
      monto_venta_bruta = $('#venta_bruta_'+campo).attr('valor')
      monto_venta_bruta = parseFloat(monto_venta_bruta)
      value = monto_venta_bruta - parseFloat($(this).val())
    else
      value = monto_venta_bruta-($(this).val())
    $('#venta_neta_'+campo).attr('valor',value)
    $('#venta_neta_'+campo).number(value,2,',','.')
  ".editar_costo_venta input"


$("#btn_save_venta").on "click", ->
  if $(".campo_editar").length > 0
    for element, index in $('.campo_editar')
      elemento = $('#'+element.id)
      bandera = elemento.hasClass('editar_monto_venta')
      campo = elemento.attr('campo')
      valor = $("#mount_"+campo)
      elemento_1 = $("#nota_credito_"+campo)
      nota_credito = elemento_1.attr('valor')
      costo_venta = $("#costo_venta_"+campo).attr('valor')
      opcion = elemento.attr('opcion')
      if bandera || opcion == 'update'
        $.ajax
          type: "POST"
          url: "/dynamic_venta_diaria/guardar_ventas"
          dataType: "JSON"
          data:
            valor: valor.attr('valor')
            nota_credito: nota_credito
            costo_venta: costo_venta
            codigo: elemento.attr('codigo')
            fecha: elemento.attr('fecha')
            opcion: elemento.attr('opcion')
            campo: campo
            identificador: elemento.attr('identificador')
            id: elemento.attr('campo')
            year: $("#date_lapso_year").val()
            month: $("#venta_diaria_select_month").val()
            tienda_id: $("#tienda_id").val()
          success: (data) ->
            if(data[0]['result'])
              $.blockUI({
                message: $('div.growlUI.save'),
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
              run = () ->
                $(".actualizar_ventas").change()
              setTimeout(run, 1000)
            else
              console.log(data)
          error: (data)->
            $.unblockUI()
            console.log(data)
  else
    $.blockUI({
      message: $('div.growlUI.mensaje'),
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


$("#btn_cancelar_venta").on "click", ->
  if $(".campo_editar").length > 0
    if confirm('¿Está seguro de cancelar los cambios?')
      $(".actualizar_ventas").change()
#  $( "#dialog-confirm").dialog
#    resizable: false,
#    height:140,
#    modal: true,
#    buttons: {
#      "Delete all items": ->
#        $( this ).dialog("close")
#    },
#    Cancel: ->
#      $(this).dialog( "close" );

$(".actualizar_auditoria_ventas").on "change", ->
  console.log(".actualizar_auditoria_ventas")
  $.ajax
    type: "POST"
    url: "/dynamic_venta_auditoria/auditoria"
    dataType: "JSON"
    data:
      year: $("#date_lapso_year").val()
      month: $("#venta_diaria_select_month").val()
    before_send: $.blockUI({message: 'Por favor espere...'})
    success: (data) ->
      value = data[0]['total_ventas']
      $("#total_ventas_mes").text(value)
      value1 = data[0]['total_ventas_neta']
      $("#total_ventas_neta_mes").val(value)
      $("#total_ventas_neta_mes").number(value,2,',','.')
      value2 = data[0]['total_ventas_bruto']
      $("#total_ventas_mes_bruto").text(value2)
      $("#monto_canon_fijo").text(data[0]['total_canon_fijo'])
      $("#monto_canon_x_venta").text(data[0]['total_canon_variable'])
      $("#total_canon").text(data[0]['total_canon'])

      $("#tbody_auditoria_ventas").empty()
      $("#tbody_mall_ventas").empty()

      for element, index in data[0]['tiendas']
        @cadena_check = "title='Falta Registrar Ventas'"
        @cadena_recibo =  "title='Falta Enviarle Recibo de Cobro'"
        if !element.editable
          @cadena_check = "checked title='Ventas Actualizadas'"
        if element.recibos_cobro
          @cadena_recibo = "checked title='Recibo Cobro Enviado'"

        $("#tbody_auditoria_ventas").append("<tr><td>"+element.tienda+"</td><td>"+element.actividad_economica+"</td>" +
          "<td>"+element.local+"</td>" +
          "<td>"+element.tipo_canon+"</td><td class='clase_monto'>"+element.canon_fijo+"</td>" +
          "<td class='clase_monto'>"+element.venta_mes+"</td><td class='clase_monto'>"+element.canon_variable+"</td>" +
          "<td class='clase_monto'>"+element.canon_alquiler+"</td>" +
          "<td><input type='checkbox' disabled='disabled' name='ventas_actualizadas' value='"+element.tienda_id+"' "+@cadena_check+" /></td>" +
          "<td><input type='checkbox' name='recibo_cobro_"+element.tienda_id+"' disabled='disabled' "+@cadena_recibo+" /></td>" +
          "<td><a href='/ventas_tiendas/"+element.tienda_id+"/"+data[0]['mes']+"'>Ver Ventas diarias</a></td></tr>")

        $("#tbody_mall_ventas").append("<tr><td>"+element.tienda+"</td><td>"+element.actividad_economica+"</td>" +
          "<td>"+element.local+"</td><td>"+element.nivel_ubicacion+"</td>" +
          "<td>"+element.tipo_canon+"</td><td class='clase_monto'>"+element.ventas_bruto_mes+"</td>" +
          "<td class='clase_monto'>"+element.canon_fijo+"</td><td class='clase_monto'>"+element.canon_variable+"</td>" +
          "<td class='clase_monto'>"+element.total_canon+"</td>" +
          "<td><a href='/ventas_tiendas/"+element.tienda_id+"/"+data[0]['mes']+"'>Ver Ventas diarias</a></td></tr>")

    error: (data)->
      console.log(data)
    complete: ->
      $.unblockUI()

$(".actualizar_ventas_mes").on "change", ->
  $.ajax
    type: "POST"
    url: "/dynamic_ventas_mes/ventas"
    dataType: "JSON"
    data:
      year: $("#date_lapso_year").val()
    before_send: $.blockUI({message: 'Por favor espere...'})
    success: (data) ->
      $("#tbody-ventas-mall").empty()
      meses = ['Enero', 'Febrero', 'Marzo', 'Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']
      cant_meses = data[0]['meses']

      for num in [0..cant_meses-1]
        $("#tbody-ventas-mall").append("<tr><th>"+ data[0]['ventas'][num].mes+"</th><td>"+data[0]['ventas'][num].monto_ventas+"</td><td>"+data[0]['ventas'][num].canon_fijo+"</td><td>"+data[0]['ventas'][num].canon_variable+"</td><td>"+data[0]['ventas'][num].canon_total+"</td></tr>")

      $("#suma_total").text(data[0]['total_ventas'])
      $("#total_canon_fijo").text(data[0]['total_canon_fijo'])
      $("#total_canon_x_ventas").text(data[0]['total_canon_variable'])
      $("#total_canons").text(data[0]['total_canon'])

    error: (data)->
      $.unblockUI()
      console.log(data)
    complete: ->
      $.unblockUI()


$("#btn-send-recibos").on "click", ->
  now = new Date()
  anio_hoy = now.getFullYear()
  mes_hoy = now.getMonth()+1

  year = $("#date_lapso_year option:selected").val()
  month = $("#venta_diaria_select_month option:selected").val()
  if ((String(year) == String(anio_hoy)) and (String(month) == String(mes_hoy)))
    $.blockUI({
      message: 'Esta opcion es valida solo para meses anteriores',
    });
    $('.blockOverlay').attr('title','Click para cerrar').click($.unblockUI);
  else
    sel_actualizada = $('input[name=ventas_actualizadas]:checked')

    if (sel_actualizada.length > 0)
      tiendas = new Array()
      notificar = new Array()
      for element, index in sel_actualizada
        if !$('input[name=recibo_cobro_'+element.value+']').is(':checked')
          tiendas.push(element.value)
      if tiendas.length > 0
        $.ajax
          type: "POST"
          url: "/dynamic_pago_alquilers/recibos_cobro"
          dataType: "JSON"
          async: false
          data:
            year: $("#date_lapso_year").val()
            month: $("#venta_diaria_select_month").val()
            tiendas: tiendas
          success: (data) ->
            console.log(data)
            if data[0]['result']
              for element, index in data[0]['tiendas']
                $('input[name=recibo_cobro_'+element+']').prop('checked',true)
            $.blockUI({
              message: 'Recibos de Cobro enviados correctamente',
              timeout: 3000,
            });
            run = () ->
              $(".actualizar_auditoria_ventas").change()
            setTimeout(run, 1000)

          error: (data)->
            $.unblockUI()
            console.log(data)
          complete: ->
            a=1
      else
        $.blockUI({
          message: 'Ya se enviaron los recibos de cobro',
        });
        setTimeout($.unblockUI, 2000);
    else
      $.blockUI({
        message: 'No hay tiendas actualizadas para enviar recibos de cobro',
      });
      setTimeout($.unblockUI, 2000);

$("#btn_cerrar_mes_venta").on "click", ->
  now = new Date()
  anio_hoy = now.getFullYear()
  mes_hoy = now.getMonth()+1

  year = $("#date_lapso_year option:selected").val()
  month = $("#venta_diaria_select_month option:selected").val()
  if ((String(year) == String(anio_hoy)) and (String(month) == String(mes_hoy)))
    $.blockUI({
      message: 'Esta opcion es valida solo para meses anteriores',
    });
    $('.blockOverlay').attr('title','Click para cerrar').click($.unblockUI);
  else
    if confirm('¿Está seguro de cerrar las ventas del mes?')
      year = $("#date_lapso_year").val()
      month = $("#venta_diaria_select_month").val()
      tienda = $("#tienda_id").val()

      $.ajax
        type: "POST"
        url: "/dynamic_venta_diaria/cerrar_ventas_mes"
        dataType: "JSON"
        async: false
        data:
          year: year
          month: month
          tienda: tienda
        success: (data) ->
          if data[0]['result'] == 1
            mensaje = 'mensaje_cierre'
          else
            if data[0]['result'] == 2
              mensaje = 'mensaje_ya_cerro'
            else
              mensaje = 'mensaje_no_puede_cerrar'
          $.blockUI({
            message: $('div.growlUI.'+mensaje),
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
          if data[0]['result'] == 1
            run = () ->
              $(".actualizar_ventas").change()
            setTimeout(run, 3000)
        error: (data)->
          #$.unblockUI()
          console.log(data)
        complete: ->
          a=1

