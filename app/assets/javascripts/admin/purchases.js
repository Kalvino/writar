var renderMap = function(mapData){
    $("#purchase-map").empty();
    $('#purchase-map').vectorMap({
        map: 'world_mill_en',
        backgroundColor: "transparent",
        zoomOnScroll: false,
        regionStyle: {
            initial: {
                fill: '#e4e4e4',
                "fill-opacity": 0.9,
                stroke: 'none',
                "stroke-width": 0,
                "stroke-opacity": 0
            }
        },

        series: {
            regions: [{
                values: mapData,
                scale: ["#1ab394", "#22d6b1"],
                normalizeFunction: 'polynomial'
            }]
        },

        onRegionTipShow: function(e, el, code){
            count = mapData[code] == undefined ? "0" : mapData[code];
            el.html(el.html()+' (Purchases: '+ count +')');
        }
    });
}

$(document).ready(function() {
    $('#essay-purchases').DataTable({
        bProcessing: true,
        bServerSide: true,
        sAjaxSource: $('#essay-purchases').data('source'),
        iDisplayLength: 10,
        aaSorting: [[4, "desc"]],
        aoColumnDefs: [
            { bSortable: false, aTargets: [ 2,5 ] }
        ],
        fnDrawCallback : function() {
            // callback after ajax here
        },
        fnServerData: function (sSource, aoData, fnCallback) {
            $.getJSON(sSource, aoData, function (json) {
                /* Do whatever additional processing you want on the callback, then tell DataTables */
                renderMap(json.mapData);
                fnCallback(json)
            });
        },
        dom: '<"html5buttons"B>lTfgitp',
        buttons: [
            {extend: 'copy'},
            {extend: 'csv'},
            {extend: 'excel', title: 'Paper Purchase History'},
            {extend: 'pdf', title: 'Paper Purchase History'},
            {
                extend: 'print',
                customize: function (win) {
                    $(win.document.body).addClass('white-bg');
                    $(win.document.body).css('font-size', '10px');

                    $(win.document.body).find('table')
                        .addClass('compact')
                        .css('font-size', 'inherit');
                }
            }
        ]

    });

});
