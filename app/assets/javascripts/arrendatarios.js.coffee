#= require bootstrapValidator/bootstrapValidator

jQuery(document).ready ->

  $('#form_arrendatarios').bootstrapValidator
    feedbackIcons:
      valid: 'fa fa-check ',
      invalid: 'fa fa-times',
      validating: 'fa fa-refresh'
    live: 'submitted'
    fields:
      "arrendatario[nombre]":
        validators:
          notEmpty:
            message: "El nombre de la empresa es obligatorio"
      "arrendatario[rif]":
        validators:
          notEmpty:
            message: "El documento de identidad de la empresa es obligatorio"
      "arrendatario[direccion]":
        validators:
          notEmpty:
            message: "La dirección de la empresa es obligatoria"
      "arrendatario[telefono]":
        validators:
          notEmpty:
            message: "El teléfono de la empresa es obligatorio"
      "arrendatario[nombre_rl]":
        validators:
          notEmpty:
            message: "El nombre del representante legal es obligatorio"
      "arrendatario[cedula_rl]":
        validators:
          notEmpty:
            message: "El documento de identidad del representante legal es obligatorio"
      "arrendatario[email_rl]":
        validators:
          notEmpty:
            message: "El e-mail del representante legal es obligatorio"
      "arrendatario[telefono_rl]":
        validators:
          notEmpty:
            message: "El teléfono del representante legal es obligatorio"
      "arrendatario[registro_mercantil]":
        validators:
          notEmpty:
            message: "La inscripción del registro Mercantil de la empresa es obligatoria"


  $('#table_inquilinos_index').dataTable
    'dom': 'T<"clear">lfrtip'
    'tableTools':
      'sSwfPath': '../assets/dataTables/swf/copy_csv_xls_pdf.swf'
      "aButtons": [
        {
          "sExtends":     "copy",
          "sButtonText": "Copiar"
        },
        {
          "sExtends":     "csv",
          "sButtonText": "Excel"
        },
        {
          "sExtends":     "pdf",
          "sButtonText": "PDF"
        },
        {
          "sExtends":     "print",
          "sButtonText": "Imprimir"
        },
        ]
    "language": {
      "sProcessing":    "Procesando...",
      "sLengthMenu":    "Mostrar _MENU_ Registros",
      "sZeroRecords":   "No se encontraron resultados",
      "sEmptyTable":    "Ningún dato disponible en esta tabla",
      "sInfo":          "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
      "sInfoEmpty":     "Mostrando registros del 0 al 0 de un total de 0 registros",
      "sInfoFiltered":  "(filtrado de un total de _MAX_ registros)",
      "sInfoPostFix":   "",
      "sSearch":        "Buscar: ",
      "sUrl":           "",
      "sInfoThousands":  ",",
      "sLoadingRecords": "Cargando...",
      "oPaginate": {
        "sFirst":    "Primero",
        "sLast":    "Último",
        "sNext":    "Siguiente",
        "sPrevious": "Anterior"
      },
      "oAria": {
        "sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
        "sSortDescending": ": Activar para ordenar la columna de manera descendente"
      }
    }