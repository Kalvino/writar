$(document).ready(function(){
    $('#students').DataTable({
        bProcessing: true,
        bServerSide: true,
        sAjaxSource: $('#students').data('source'),
        iDisplayLength: 25,
        aaSorting: [[5, "desc"]],
        aoColumnDefs: [
            { bSortable: false, aTargets: [ 6 ] }
        ],
        fnDrawCallback : function() {
            // callback after ajax here
        }
    });

    $("#student-orders").DataTable({
        bProcessing: true,
        bServerSide: true,
        iDisplayLength: 10,
        sAjaxSource: $('#student-orders').data('source'),
        aoColumnDefs: [
            { bSortable: false, aTargets: [ 4 ] }
        ],
        aaSorting: [[2, "desc"]],
        fnDrawCallback : function() {
        }
    });

    var currTime = function(timezone){
        var currentTime = moment();
        return currentTime.tz(timezone).format('Do MMMM, h:mm:ss a');
    };
    if($(".user-time").length){
        var timezone = $(".user-time").data("timezone");
        setInterval(function(){
            $(".user-time").text("Local time: " + currTime(timezone));
        },1000);
    }
});



