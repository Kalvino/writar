$(document).ready(function(){
    $('#users').DataTable({
        bProcessing: true,
        bServerSide: true,
        sAjaxSource: $('#users').data('source'),
        iDisplayLength: 10,
        aaSorting: [[4, "desc"]],
        aoColumnDefs: [
            { bSortable: false, aTargets: [ 5 ] }
        ],
        fnDrawCallback : function() {
            // callback after ajax here
            $("table#users").find('td:nth-child(6)').addClass("text-right");
        }
    });

    $("#seller-essays").DataTable({
        bProcessing: true,
        bServerSide: true,
        iDisplayLength: 10,
        sAjaxSource: $('#seller-essays').data('source'),
        aoColumnDefs: [
            { bSortable: false, aTargets: [ 6,7 ] }
        ],
        aaSorting: [[5, "desc"]],
        fnServerParams: function ( aoData ) {
            aoData.push( { name: "seller_id", value: $('#seller-essays').data('seller-id') }, { name: "admin", value: "true" } );
        },
        fnDrawCallback : function() {
            $('[data-toggle="tooltip"]').tooltip();
            $("table#seller-essays").find('td:nth-child(7),th:nth-child(7)').hide();
        }

    });

    $("#seller-transactions").DataTable({
        bProcessing: true,
        bServerSide: true,
        iDisplayLength: 10,
        sAjaxSource: $('#seller-transactions').data('source'),
        aoColumnDefs: [
            { bSortable: false, aTargets: [ 6 ] }
        ],
        aaSorting: [[0, "desc"]],
        fnServerParams: function ( aoData ) {
            aoData.push(
                { name: "seller_id", value: $('#seller-transactions').data('seller-id') },
                { name: "is_admin", value: "true"}
            );
        },
        fnDrawCallback : function() {
        }

    });

    $("#seller-withdrawals").DataTable({
        bProcessing: true,
        bServerSide: true,
        iDisplayLength: 10,
        sAjaxSource: $('#seller-withdrawals').data('source'),
        aoColumnDefs: [
            { bSortable: false, aTargets: [ ] }
        ],
        aaSorting: [[0, "desc"]],
        fnServerParams: function ( aoData ) {
            aoData.push( { name: "seller_id", value: $('#seller-withdrawals').data('seller-id') } );
        },
        fnDrawCallback : function() {
        }
    });

    $("#seller-uploads").sparkline($("#seller-uploads").data("upload-count"), {
        type: 'line',
        width: '100%',
        height: '50',
        lineColor: '#1ab394',
        fillColor: "transparent"
    });

    $("#take-ownership").click(function(e){
        e.preventDefault();

        var link = $(this);
        link.addClass("disabled");
        var href = link.attr("href");

        swal({
            title: "Are you sure?",
            text: "This action will transfer the sellers paper to admin",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "Yes, Confirm!",
            closeOnConfirm: false
        }, function () {
            $.ajax({
                type: "PATCH",
                url: href,
                success: function(data){
                    swal("Success!", data.message, "success");
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    sweetAlert("Oops...", "You may not have permission to perform this operation", "error");
                    window.location = window.location.href
                }
            });
        });


    })

});
