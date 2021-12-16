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
            aoData.push( { name: "seller_id", value: $('#withdrawals').data('seller-id') } );
        },
        fnDrawCallback : function() {
            $("table#withdrawals").find('td:nth-child(2),th:nth-child(2)').hide();
        }

    });
});
