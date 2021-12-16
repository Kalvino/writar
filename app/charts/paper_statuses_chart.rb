class PaperStatusesChart
  COLORS = { approved: "#1ab394", pending: "#f8ac59", denied: "#ed5565" }

  def initialize(year)
    @papers_count = Essay.year(year).count.to_f
  end

  def draw
    chart_data = {
        chart: {
            plotBackgroundColor: nil,
            plotBorderWidth: nil,
            plotShadow: false,
            type: 'pie'
        },
        title: {
            text: 'Papers By Status'
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.count} ({point.percentage:.1f})%</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true
                },
                showInLegend: false
            }
        },
        series: [
            {
                name: 'Total',
                colorByPoint: true,
                data: []
            }
        ]
    }

    Essay.statuses.keys.each do |status|
      status_count = Essay.send(status).count
      percentage = ((status_count/@papers_count)*100).round(2)
      data = { name: "#{status.titleize} Papers", y: percentage, count: status_count, color: COLORS[status.to_sym] }
      data.merge!(sliced: true, selected: true) if status == "pending"
      chart_data[:series][0][:data] << data
    end

    return chart_data
  end
end
