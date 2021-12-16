require 'capybara/poltergeist'

class Edusson
  attr_reader :spider, :username, :password, :base_url, :first_run

  def initialize(first_run=false)
    @spider     = configure_spider
    @username   = "sengerakemunto@yahoo.com"
    @password   = "b2tj^anVv"
    @base_url   = "https://edusson.com"
    @first_run  = first_run
  end

  def available_orders
    login
    url = "#{base_url}/writer/orders/available"
    puts "=> [INFO] Loading url: #{url}"

    spider.visit(url)

    show_more_orders if first_run
    spider.all(".my-orders_new__name a").map{|o| o[:href] }
  end

  def scrape
    orders = available_orders
    orders.each do |url|
      puts "=> [INFO] Loading url: #{url}"

      spider.visit(url)

      original_title = spider.find("h1").text

      if spider.has_link?("Read more")
        spider.find("a.js_show_description").trigger('click')
        description = spider.find("p.post-info.js_full_desc").text
      else
        description = spider.find("p.post-info").text
      end

      next if description.match(/instructions will be uploaded later/i)

      details = {
          title: original_title.gsub(/Order \d+:/, '').strip[0..200],
          content: description.strip,
          retrieved_from: url
      }

      question = Question.find_by_title(details[:title])

      next if question.present?

      question = Question.find_by_retrieved_from(url)
      if question.nil?
        question  = Question.create!(details)
        puts "=> [INFO] * Created question: #{question.title[0..100]}"
      else
        question.update(content: details[:content]) if question.status == "pending"
        puts "=> [INFO] * Updated question: #{question.title[0..100]}"
      end
      sleep 5
    end
  end

  private

  def configure_spider
    Capybara.register_driver :poltergeist do |app|
      options = { js_errors: false, debug: false, timeout: 240, phantomjs_logger: File.open("log/bot.log", 'w'),
                  phantomjs_options: ['--ignore-ssl-errors=false', '--load-images=false']
      }
      Capybara::Poltergeist::Driver.new(app, options)
    end
    spider = Capybara::Session.new(:poltergeist)
    user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36"
    spider.driver.headers = {"User-Agent" => user_agent}

    return spider
  end

  def wait_till_visible(text)
    loop do
      element = spider.has_content?(text)
      print "."
      break if element
      sleep 0.5
    end
  end

  def show_more_orders(pages=10)
    (0...pages).each do |page|
      spider.click_link("Show more")
      wait_till_visible("Show more")
    end
  end

  def login
    url = "#{base_url}?login-first=1"
    puts "=> [INFO] Loading url: #{url}"
    print "=> [INFO] Loggin in"

    spider.visit(url)
    wait_till_visible("Please enter your email to proceed")

    spider.fill_in("_pre_login_username", with: username)

    spider.within(".js_login_loading_hide") do
      spider.click_button('Continue')
    end

    wait_till_visible(username)
    spider.fill_in("_password", with: password)

    spider.within(".js_login_loading_hide") do
      spider.click_button('Log in')
    end

    wait_till_visible("Orders")
    print "Success!"
    puts "\n\n"
  end
end
