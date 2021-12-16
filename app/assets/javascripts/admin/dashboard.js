$(document).ready(function(){
    $(".purchase_by_year").click(function(){
        var url = $(this).data("source");

        $('.purchase_by_year').removeClass('active');
        $(this).addClass('active');

        renderPurchasesChart(url);
    });

    $(".orders_by_year").click(function(){
        var url = $(this).data("source");

        $('.orders_by_year').removeClass('active');
        $(this).addClass('active');

        renderOrdersChart(url);
    });
    
    if( $("#dashboard-purchases").length){
        var purchase_chart_url = $("#dashboard-purchases").data("href");

        renderPurchasesChart(purchase_chart_url);
    }
    if( $("#dashboard-orders").length){
        var orders_url = $("#dashboard-orders").data("href");

        renderOrdersChart(orders_url);
    }
    
    if($("#purchase-heat-map").length){
        var heatmapDiv = $("#purchase-heat-map");
        if(heatmapDiv.length){
            var purchase_heatmap_url = heatmapDiv.data("url");

            $.ajax({
                type: "GET",
                url: purchase_heatmap_url,
                success: function(data){
                    renderPurchaseHeatMap(data);
                }
            });
        }
    }

    if($("#papers-chart").length){
        var paper_statuses_url = $("#papers-chart").data("url");
        $.ajax({
            type: "GET",
            url: paper_statuses_url,
            success: function(data){
                $('#papers-chart').highcharts(data);
            }
        });
    }
});

var renderPurchaseHeatMap = function(data){
    $('#purchase-heat-map').vectorMap({
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
                values: data,
                scale: ["#1ab394", "#22d6b1"],
                normalizeFunction: 'polynomial'
            }]
        },

        onRegionTipShow: function(e, el, code){
            count = data[code] == undefined ? "0" : data[code];
            el.html(el.html()+' (Purchases: '+ count +')');
        }
    });
}

var renderPurchasesChart = function(url){
    $.ajax({
        type: "GET",
        url: url,
        success: function(data){
            $('#dashboard-purchases').highcharts(data)
        }
    });
}

var renderOrdersChart = function(url){
    $.ajax({
        type: "GET",
        url: url,
        success: function(data){
            $('#dashboard-orders').highcharts(data)
        }
    });
}
