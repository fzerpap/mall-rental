# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require jquery.blockUI.js
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
      $("#total_ventas").val(data[0]['suma'])
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
        else
          @clase = ''
          @clase_2 = ''
          @title = 'Campo no editable'

        if element.id == '-1'
          @opcion = 'new'
        else
          @opcion = 'update'

        if @total_cant_ventas == 0 && !data[0]['mes_actual']
          $("#btn_up_documento_venta").prop('disabled', false);

        $("#tbody_venta_bruta").append("<tr><td>"+element.fecha+"</td><td id='mount_"+element.dia+"' class='"+@clase+"' identificador='"+element.id+"'  opcion='"+@opcion+"' title='"+@title+"' fecha='"+element.fecha+"' campo='"+element.dia+"'>"+element.monto+"</td><td id='nota_credito_"+element.dia+"' class='"+@clase_2+"' opcion='"+@opcion+"' identificador='"+element.id+"' title='"+@title+"' fecha='"+element.fecha+"' campo='"+element.dia+"' >"+element.monto_notas_credito+"</td><td id='venta_bruta_"+element.dia+"' campo='"+element.dia+"'>"+element.monto_venta_bruta+"</td></tr>")
        $("#tbody_venta_neta").append("<tr><td>"+element.fecha+"</td><td id='mount_"+element.dia+"' class='"+@clase+"' identificador='"+element.id+"' opcion='"+@opcion+"' title='"+@title+"' fecha='"+element.fecha+"' campo='"+element.dia+"'>"+element.monto+"</td><td id='nota_credito_"+element.dia+"' class='"+@clase_2+"' opcion='"+@opcion+"' identificador='"+element.id+"' title='"+@title+"' fecha='"+element.fecha+"' campo='"+element.dia+"' >"+element.monto_notas_credito+"</td><td id='venta_bruta_"+element.dia+"' campo='"+element.dia+"'>"+element.monto_venta_bruta+"</td><td id='venta_neta_"+element.dia+"' campo='"+element.dia+"'>"+element.monto_costo_venta+"</td><td id='venta_bruta_"+element.dia+"' campo='"+element.dia+"'>"+element.monto_venta_neta+"</td></tr>")

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
      $('input',this).focus()
  ".editar_monto_notas_credito"

$(".tbody_ventas_diarias").on
  blur:->
    if ($(this).val() != '')
      valor = $(this).attr('valor')
      $(this).parent().addClass('campo_editar')
      $(this).parent().text($(this).val())
      $(this).remove()
    else
      $(this).parent().text(valor)
      $(this).remove()
  ".editar_monto_venta input"

$(".tbody_ventas_diarias").on
  blur:->
    if ($(this).val() != '')
      campo = $(this).attr('campo')
      valor = $(this).attr('valor')
      $(this).parent().addClass('campo_editar')
      $(this).parent().text($(this).val())
      $(this).remove()
    else
      $(this).parent().text(valor)
      $(this).remove()
  ".editar_monto_notas_credito input"

$(".tbody_ventas_diarias").on
  keyup:->
    campo = $(this).attr('campo')
    if $(this).val() == '' && $(this).val() <= 0
      value = $('#mount_'+campo).text()
    else if $(this).val() != ''
      monto = $('#mount_'+campo).text().replace(".", "")
      monto = parseFloat(monto.replace(",", "."))
      value = monto - parseFloat($(this).val())
    else
      value = $('#mount_'+campo).text()-($(this).val())

    $('#venta_bruta_'+campo).text(value)
  ".editar_monto_notas_credito input"

$(".tbody_ventas_diarias").on
  keyup:->
    campo = $(this).attr('campo')
    if $(this).val() == '' && $(this).val() <= 0
      if $('#nota_credito_'+campo).text() == '' && $('#nota_credito_'+campo).text() <= 0
        value = 0
      else
        value = $('#nota_credito_'+campo).text()
    else if $(this).val() != ''
      if $('#nota_credito_'+campo).text() != ''
        nota_cred = $('#nota_credito_'+campo).text().replace(".", "")
        nota_cred = parseFloat(nota_cred.replace(",", "."))
      else
        nota_cred = 0
      value = parseFloat($(this).val()) - nota_cred
    else
      value = parseFloat($(this).val()) - $('#nota_credito_'+campo).text()

    $('#venta_bruta_'+campo).text(value)
  ".editar_monto_venta input"

$("#btn_save_venta").on "click", ->
  if $(".campo_editar").length > 0
    for element, index in $('.campo_editar')
      elemento = $('#'+element.id)
      bandera = elemento.hasClass('editar_monto_venta')
      campo = elemento.attr('campo')
      valor = $("#mount_"+campo)
      elemento_1 = $("#nota_credito_"+campo)
      nota_credito = elemento_1.text()
      opcion = elemento.attr('opcion')
      if bandera || opcion == 'update'
        $.ajax
          type: "POST"
          url: "/dynamic_venta_diaria/guardar_ventas"
          dataType: "JSON"
          data:
            valor: valor.text()
            nota_credito: nota_credito
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
            console.log(data)
          complete: ->
            $(".actualizar_ventas").change()
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
  $.ajax
    type: "POST"
    url: "/dynamic_venta_auditoria/auditoria"
    dataType: "JSON"
    data:
      year: $("#date_lapso_year").val()
      month: $("#ventas_select_month").val()
    before_send: $.blockUI({message: 'Por favor espere...'})
    success: (data) ->
      $("#total_ventas_mes").val(data[0]['total_ventas'])
      $("#monto_canon_fijo").val(data[0]['suma_canon_fijo'])
      $("#monto_canon_x_venta").val(data[0]['suma_canon_ventas'])
      $("#total_canon").val(data[0]['total'])

      $("#tbody_auditoria_ventas").empty()
      $("#tbody_mall_ventas").empty()
      for element, index in data[0]['tiendas']
        @cadena_check = "title='Falta Registrar Ventas'"
        @cadena_recibo =  "title='Falta Enviarle Recibo de Cobro'"
        if element.actualizada
          @cadena_check = "checked title='Ventas Actualizadas'"
        if element.recibos_cobro
          @cadena_recibo = "checked title='Recibo Cobro Enviado'"

        $("#tbody_auditoria_ventas").append("<tr><td>"+element.tienda+"</td><td>"+element.actividad_economica+"</td>" +
          "<td>"+element.local+"</td>" +
          "<td>"+element.tipo_canon+"</td><td>"+element.canon_fijo+"</td>" +
          "<td>"+element.ventas_mes+"</td><td>"+element.canon_x_ventas+"</td>" +
          "<td>"+element.total_canon+"</td>" +
          "<td><input type='checkbox' disabled='disabled' name='ventas_actualizadas' value='"+element.tienda_id+"' "+@cadena_check+" /></td>" +
          "<td><input type='checkbox' name='recibo_cobro_"+element.tienda_id+"' disabled='disabled' "+@cadena_recibo+" /></td>" +
          "<td><a href='/ventas_tiendas/"+element.tienda_id+"/"+data[0]['mes']+"'>Ver Ventas diarias</a></td></tr>")

        $("#tbody_mall_ventas").append("<tr><td>"+element.tienda+"</td><td>"+element.actividad_economica+"</td>" +
          "<td>"+element.local+"</td><td>"+element.nivel_ubicacion+"</td>" +
          "<td>"+element.tipo_canon+"</td><td>"+element.canon_fijo+"</td>" +
          "<td>"+element.ventas_mes+"</td><td>"+element.canon_x_ventas+"</td>" +
          "<td>"+element.total_canon+"</td>" +
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
      mes_fin = data[0]['mes_actual']-1

      for num in [0..mes_fin]
        $("#tbody-ventas-mall").append("<tr><th>"+meses[num]+"</th><td>"+data[0]['ventas'][num].ventas+"</td><td>"+data[0]['ventas'][num].canon_fijo+"</td><td>"+data[0]['ventas'][num].canon_x_ventas+"</td><td>"+data[0]['ventas'][num].total_mes_canon+"</td></tr>")

      $("#suma_total").text(data[0]['suma_total'])
      $("#total_canon_fijo").text(data[0]['total_canon_fijo'])
      $("#total_canon_x_ventas").text(data[0]['total_canon_x_ventas'])
      $("#total_canons").text(data[0]['total_canons'])

    error: (data)->
      console.log(data)
    complete: ->
      $.unblockUI()

$("#btn-send-recibos").on "click", ->
  now = new Date()
  anio_hoy = now.getFullYear()
  mes_hoy = now.getMonth()+1

  year = $("#date_lapso_year option:selected").val()
  month = $("#ventas_select_month option:selected").val()
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
            month: $("#ventas_select_month").val()
            tiendas: tiendas
          success: (data) ->
            if data[0]['result']
              for element, index in data[0]['tiendas']
                $('input[name=recibo_cobro_'+element+']').prop('checked',true)
              $.blockUI({
                message: 'Recibos de Cobro enviados correctamente',
                timeout: 3000,
              });
          error: (data)->
            #$.unblockUI()
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
