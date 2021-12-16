$(document).ready(function(){
    $("#admin-essays").DataTable({
        bProcessing: true,
        bServerSide: true,
        iDisplayLength: 10,
        sAjaxSource: $('#admin-essays').data('source'),
        aoColumnDefs: [
            { bSortable: false, aTargets: [ 6,7 ] }
        ],
        aaSorting: [[5, "desc"]],
        fnServerParams: function ( aoData ) {
            aoData.push( { name: "admin_id", value: $('#admin-essays').data('admin-id') }, { name: "admin", value: "true" } );
        },
        fnDrawCallback : function() {
            $('[data-toggle="tooltip"]').tooltip();
            $("table#admin-essays").find('td:nth-child(7),th:nth-child(7)').hide();

        }
    });
})