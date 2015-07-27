#= require bootstrapValidator/bootstrapValidator
#= require jasny/jasny-bootstrap
#= require numeric

jQuery(document).ready ->

  $('#select_tipo_contrato_servicio').change ->
    if ($(this).val() == '1' || $(this).val() == '2')
      $('#precio_servicio').show()
      $('#datos_monto').show()
      $('#porc_ingresos').hide()
    else
      $('#precio_servicio').hide()
      $('#datos_monto').hide()
      $('#porc_ingresos').show()