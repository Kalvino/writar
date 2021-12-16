class QuestionStatusesChart
  COLORS = { approved: "#1ab394", pending: "#f8ac59", denied: "#ed5565" }

  def initialize(year)
    @questions_count = Question.year(year).count.to_f
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
            text: 'Questions By Status'
        },
        tooltip: {
            pointFormat: '{series.name}: <b> {point.count} ({point.percentage:.1f})%</b>'
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

    Question.statuses.keys.each do |status|
      status_count = Question.send(status).count
      percentage = ((status_count/@questions_count)*100).round(2)
      data = { name: "#{status.titleize} Questions", y: percentage, color: COLORS[status.to_sym], count: status_count }
      data.merge!(sliced: true, selected: true) if status == "pending"
      chart_data[:series][0][:data] << data
    end

    return chart_data
  end
end
