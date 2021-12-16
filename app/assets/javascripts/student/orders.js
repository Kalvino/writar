$(document).ready(function(){
    $("#student-orders").DataTable({
        bProcessing: true,
        bServerSide: true,
        iDisplayLength: 10,
        sAjaxSource: $('#student-orders').data('source'),
        aoColumnDefs: [
            { bSortable: false, aTargets: [ 0,5 ] }
        ],
        aaSorting: [[2, "desc"]],
        fnServerParams: function ( aoData ) {
            aoData.push( { name: "student_id", value: $('#student-orders').data('student-id') } );
        },
        fnDrawCallback : function() {
            $('[data-toggle="tooltip"]').tooltip();
        }
    });

    $("a#next").click(function (e) {
        e.preventDefault();

        $("#price-calculation").removeClass("hidden");
        $("#paper-details").addClass("hidden");
        $("html, body").animate({ scrollTop: 0 }, "slow");
        $('form#order-form').calculateCost();
    });

    $("a#back").click(function (e) {
        e.preventDefault();

        $("#price-calculation").addClass("hidden");
        $("#paper-details").removeClass("hidden");
        $("html, body").animate({ scrollTop: 0 }, "slow");
        $('form#order-form').calculateCost();
    });

    $(".touchspin").TouchSpin({
        verticalbuttons: false,
        min : 1,
        buttondown_class: 'btn btn-white',
        buttonup_class: 'btn btn-white'
    });

    $("#apply-coupon").click(function(e){
        e.preventDefault();

        $(this).prop("disabled",true);
        $("#code").prop("readonly",true);
        $(this).parents("form").submit();
    });
});
