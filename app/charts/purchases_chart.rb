class PurchasesChart
  COLORS = ["#1ab394","#1C84C6","#7cb5ec", "#434348", "#90ed7d", "#f7a35c", "#8085e9", "#f15c80", "#e4d354", "#2b908f", "#f45b5b",
            "#91e8e1"]

  def initialize(year)
    @year = year.nil? ? Date.today.year : year.to_i
    @purchases = Purchase.year(@year).select(:essay_id,:created_at,:mc_gross)
  end

  def draw
    chart_data = {
        chart: {
            zoomType: 'xy'
        },
        colors: ["#1ab394","#1C84C6"],
        title: {
            text: 'Annual Sales vs Purchase Count'
        },
        subtitle: {
            text: "Year: #{@year}"
        },
        xAxis: [{
                    categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                    crosshair: true
                }],
        yAxis: [{# Primary yAxis
                 labels: {
                     style: {
                         color: COLORS[1]
                     }
                 },
                 title: {
                     text: 'Purchases',
                     style: {
                         color: COLORS[1]
                     }
                 }
                }, {# Secondary yAxis
                    title: {
                        text: 'Sales',
                        style: {
                            color: COLORS[0]
                        }
                    },
                    labels: {
                        format: '${value} USD',
                        style: {
                            color: COLORS[0]
                        }
                    },
                    opposite: true
                }],
        tooltip: {
            shared: true
        },
        legend: {
            # layout: 'vertical',
            # align: 'left',
            # x: 120,
            # verticalAlign: 'top',
            # y: 100,
            # floating: true,
            # backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'
        },
        series: []
    }

    if @purchases.any?
      months              = Date::MONTHNAMES.slice(1,12)
      purchases_by_month  = @purchases.group_by(&:month)

      sales_data = months.each_with_object([]) do |month, arr|
        amount = purchases_by_month.has_key?(month) ? purchases_by_month[month].map(&:mc_gross).sum : nil
        arr << amount
      end

      purchases_data = months.each_with_object([]) do |month, arr|
        count = purchases_by_month.has_key?(month) ? purchases_by_month[month].count : nil
        arr << count
      end

      chart_data[:series] << {
          name: 'Sales',
          type: 'column',
          yAxis: 1,
          data: sales_data,
          tooltip: {
              valueSuffix: ' USD',
              valuePrefix: '$'
          }
      }
      chart_data[:series] << {
          name: 'Purchases',
          type: 'spline',
          data: purchases_data,
          tooltip: {
              valueSuffix: ''
          }
      }
    else
      chart_data[:series] << {
          name: 'Sales',
          type: 'column',
          yAxis: 1,
          data: Array.new(12) { 0 },
          tooltip: {
              valueSuffix: ' USD',
              valuePrefix: '$'
          }
      }
      chart_data[:series] << {
          name: 'Purchases',
          type: 'spline',
          data: Array.new(12) { 0 },
          tooltip: {
              valueSuffix: ''
          }
      }
    end

    return chart_data
  end
end
