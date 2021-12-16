class IpTimezone
  attr_reader :ip

  def initialize(ip)
    @ip = Rails.env == "development" ? "154.122.198.97" : ip
  end

  def details
    url = "http://ip-api.com/json/#{ip}"
    uri = URI(url)
    begin
      results = JSON.parse(Net::HTTP.get(uri))
      Rails.logger.info "Retrieving info for ip: #{ip}"
      Rails.logger.info "Details: #{results.inspect}"
    rescue Exception => e
      SlackBot.notify(e.message,"IP Geolocation Error", e.backtrace)
      results = { "status" => "fail","timezone" => "America/New_York" }
    end
    results
  end
end
