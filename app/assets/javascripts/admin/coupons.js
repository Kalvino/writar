$(document).ready(function(){
    $("#redemptions").DataTable({
        bProcessing: true,
        bServerSide: true,
        iDisplayLength: 10,
        sAjaxSource: $('#redemptions').data('source'),
        aoColumnDefs: [
            {bSortable: false, aTargets: [0, 2]}
        ],
        aaSorting: [[1, "desc"]]
    });
})
