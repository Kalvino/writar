$(document).ready(function(){
    $("#categories").DataTable();

    $("#category-essays").DataTable({
        bProcessing: true,
        bServerSide: true,
        iDisplayLength: 25,
        sAjaxSource: $('#category-essays').data('source'),
        aoColumnDefs: [
            { bSortable: false, aTargets: [ 6, 7 ] }
        ],
        aaSorting: [[5, "desc"]],
        fnServerParams: function ( aoData ) {
            aoData.push( { name: "category_id", value: $('#category-essays').data('category-id') } );
        },
        fnDrawCallback : function() {
            $('[data-toggle="tooltip"]').tooltip();
        }
    });
});