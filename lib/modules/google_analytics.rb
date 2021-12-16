class GoogleAnalytics
  include HTTParty
  base_uri 'https://www.googleapis.com/analytics/v3'

  def initialize
    @options = { query: { access_token: ENV["GOOGLE_API_KEY"] } }
  end

  def accounts
    query = self.class.get("/management/accounts", @options)
    accounts = JSON.parse(query.body)
    puts accounts.inspect
    accounts["items"].map { |account| {id: account["id"], name: account["name"]} }
  end

  def web_properties(account_id)
    query = self.class.get("/management/accounts/#{account_id}/webproperties", @options)
    properties = JSON.parse(query.body)
    properties["items"].map { |property| {id: property["id"], name: property["name"]} }
  end

  def profiles(account_id, web_property_id)
    query = self.class.get("/management/accounts/#{account_id}/webproperties/#{web_property_id}/profiles", @options)
    profiles = JSON.parse(query.body)
    profiles["items"].map { |property| {id: property["id"], name: property["name"]} }
  end

  def analytics(account, post)
    params = {
        :ids => "ga:#{account.analytics_profile_id}",
        :dimensions => "ga:date",
        :metrics => "ga:users,ga:newUsers,ga:bounces,ga:percentNewSessions,ga:sessions,ga:bounceRate,ga:pageviews,ga:avgTimeOnPage",
        :filters => "ga:pagePath==#{post.wp_post_path}",
        "start-date" => post.created_at.to_date.to_s,
        "end-date" => Date.today.to_s
    }

    query = self.class.get("/data/ga", {query: @options[:query].merge(params)})
    JSON.parse(query.body)
  end
end