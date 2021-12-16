$(document).ready(function(){
    $("#withdrawals").DataTable({
        bProcessing: true,
        bServerSide: true,
        iDisplayLength: 25,
        sAjaxSource: $('#withdrawals').data('source'),
        aoColumnDefs: [
            { bSortable: false, aTargets: [ ] }
        ],
        aaSorting: [[0, "desc"]],
        fnServerParams: function ( aoData ) {
        },
        fnDrawCallback : function() {
        }
    });
});
