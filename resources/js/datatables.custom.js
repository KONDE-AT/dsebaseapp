 var table = $('#myTable').DataTable({
        "language": {
        "url": "https://cdn.datatables.net/plug-ins/1.10.19/i18n/German.json"
        },
        keepConditions: true,
        "pageLength": 50,
         orderCellsTop: true,
        dom:"'<'row'<'col-sm-4'f><'col-sm-4'i><'col-sm-4 exportbuttons'Br>>'"+
            "'<'row'<'col-sm-12't>>'"+
            "'<'row'<'col-sm-6 offset-sm-6'p>>'"
        ,
         buttons: [
            {
                extend:'colvis',
                className: 'btn-outline-green',
                init: function(api, node, config) {
                    $(node).removeClass('btn-secondary')
                }
            },
            {
                extend:    'copyHtml5',
                text:      '<i class="far fa-copy"/>',
                titleAttr: 'Copy',
                className: 'btn-link',
                init: function(api, node, config) {
                    $(node).removeClass('btn-secondary')
                }
            },
            {
                extend:    'excelHtml5',
                text:      '<i class="far fa-file-excel"/>',
                titleAttr: 'Excel',
                className: 'btn-link',
                init: function(api, node, config) {
                    $(node).removeClass('btn-secondary')
                }
            },
            {
                extend:    'pdfHtml5',
                text:      '<i class="far fa-file-pdf"/>',
                titleAttr: 'PDF',
                className: 'btn-link',
                init: function(api, node, config) {
                    $(node).removeClass('btn-secondary')
                }
            }
        ],
        responsive: true,
        });
        
        $(document).ready(function() {
        $("#loader").hide();    
        $("#myTable").show();
        $('#myTable thead #filterrow th').each( function (colIndex) {
        var title = $(this).text();
        $(this).html( '<input type="text"/>' );
         $( 'input', this ).on( 'keyup change', function () {
            if ( table.column(colIndex).search() !== this.value ) {
                table
                    .column(colIndex)
                    .search( this.value )
                    .draw();
            }
        } );
        });
       
      
       
      table.responsive.recalc();
        });