$(document).ready(function(){
    var ordersTable = $("#admin-orders").DataTable({
        bProcessing: true,
        bServerSide: true,
        iDisplayLength: 10,
        sAjaxSource: $('#admin-orders').data('source'),
        aoColumnDefs: [
            {bSortable: false, aTargets: [0, 5]}
        ],
        aaSorting: [[2, "desc"]],
        fnServerParams: function ( aoData ) {
            aoData.push( { name: "is_admin", value: "true" } );
        },
        fnDrawCallback: function () {
            $('[data-toggle="tooltip"]').tooltip();
        }
    });

    $(".filter-orders").click(function(e){
        e.preventDefault();

        $("#selected-filter").html('<i class="fa fa-filter"></i> ' + $(this).text());

        var url = $(this).data("source");
        ordersTable.ajax.url(url).load();
    });

    $(".touchspin").TouchSpin({
        verticalbuttons: false,
        min : 1,
        buttondown_class: 'btn btn-white',
        buttonup_class: 'btn btn-white'
    });
});
