$(document).ready(function(){
    $("#transactions").DataTable({
        bProcessing: true,
        bServerSide: true,
        iDisplayLength: 25,
        sAjaxSource: $('#transactions').data('source'),
        aoColumnDefs: [
            { bSortable: false, aTargets: [ 6 ] }
        ],
        fnServerParams: function ( aoData ) {
            aoData.push(
                { name: "is_admin", value: "true"}
            );
        },
        aaSorting: [[0, "desc"]],
        fnDrawCallback : function() {
        }

    });
});
