$(document).ready(function(){
    $("#writer-orders").DataTable({
        bProcessing: true,
        bServerSide: true,
        iDisplayLength: 10,
        sAjaxSource: $('#writer-orders').data('source'),
        aoColumnDefs: [
            { bSortable: false, aTargets: [ 4 ] }
        ],
        aaSorting: [[2, "desc"]],
        fnDrawCallback : function() {
        }
    });

    $("#writer-transactions").DataTable({
        bProcessing: true,
        bServerSide: true,
        iDisplayLength: 10,
        sAjaxSource: $('#writer-transactions').data('source'),
        aoColumnDefs: [
            { bSortable: false, aTargets: [ 6 ] }
        ],
        aaSorting: [[0, "desc"]],
        fnServerParams: function ( aoData ) {
            aoData.push(
                { name: "writer_id", value: $('#writer-transactions').data('writer-id') },
                { name: "is_admin", value: "true"}
            );
        },
        fnDrawCallback : function() {
        }

    });
})
