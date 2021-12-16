# colors: ["#1ab394","#1C84C6","#7cb5ec", "#434348", "#90ed7d", "#f7a35c", "#8085e9", "#f15c80", "#e4d354",
#          "#2b908f", "#f45b5b", "#91e8e1"]

class OrdersChart
  COLORS = {green: "#1ab394", black: "#2f4050", in_progress: "#1C84C6", completed: "#1ab394", cancelled: "#ed5565", pending_payment: "#f8ac59"  }

  def initialize(year)
    @year = year.nil? ? Date.today.year : year.to_i
    @orders = Order.year(@year).includes(:invoice).select(:id, :created_at, :status)
  end

  def draw
    chart_data = {
        chart: {
            zoomType: 'xy',
            type: "column"
        },
        title: {
            text: 'Order Revenue vs Order Count'
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
                         color: COLORS.fetch(:black)
                     }
                 },
                 title: {
                     text: 'Orders',
                     style: {
                         color: COLORS.fetch(:black)
                     }
                 }
                }, {# Secondary yAxis
                    title: {
                        text: 'Sales',
                        style: {
                            color: COLORS.fetch(:green)
                        }
                    },
                    labels: {
                        format: '${value} USD',
                        style: {
                            color: COLORS.fetch(:green)
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

    months = Date::MONTHNAMES.slice(1,12)

    [:pending_payment, :in_progress, :completed, :cancelled].each do |status|
      orders_by_month = @orders.send(status).group_by(&:month)

      orders_data = months.each_with_object([]) do |month, arr|
        amount = orders_by_month.has_key?(month) ? orders_by_month[month].map(&:amount).sum : nil
        arr << amount
      end

      chart_data[:series] << {
          name: status.to_s.titleize,
          type: 'column',
          yAxis: 1,
          data: orders_data,
          color: COLORS.fetch(status),
          tooltip: {
              # valueSuffix: ' USD',
              valuePrefix: '$'
          }
      }
    end

    orders_by_month   = @orders.group_by(&:month)
    order_count_data  = months.each_with_object([]) do |month, arr|
      count = orders_by_month.has_key?(month) ? orders_by_month[month].count : nil
      arr << count
    end

    chart_data[:series] << {
        name: 'Orders',
        type: 'spline',
        data: order_count_data,
        tooltip: {
            valueSuffix: ''
        },
        color: COLORS.fetch(:black),
        marker: {
            lineWidth: 2,
            lineColor: COLORS.fetch(:black),
            fillColor: 'white'
        }
    }

    return chart_data
  end
end
