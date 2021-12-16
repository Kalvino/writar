$(document).ready(function(){
    $("#seller-transaction").DataTable({
        bProcessing: true,
        bServerSide: true,
        iDisplayLength: 25,
        sAjaxSource: $('#seller-transaction').data('source'),
        aoColumnDefs: [
            { bSortable: false, aTargets: [ 6 ] }
        ],
        aaSorting: [[0, "desc"]],
        fnServerParams: function ( aoData ) {
            aoData.push( { name: "seller_id", value: $('#seller-transaction').data('seller-id') } );
        },
        fnDrawCallback : function() {
            $('[data-toggle="tooltip"]').tooltip();
        }

    });
});
