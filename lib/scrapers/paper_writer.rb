require 'open-uri'

class PaperWriter
  attr_reader :url, :page

  def initialize(page = "1")
    @url  =  "http://mypaperwriter.net/blog/category/academic-questions"
    @page = page
  end

  def scrape
    document = open_page(url)
    if page == "all"
      pages = document.css(".page-numbers").map(&:text).reject{ |num| num.to_i == 0 }.map(&:to_i)
      (pages.first..pages.last).each do |page_no|
        scrape_url = page_no == 1 ? url : url + "/page/#{page_no}/"
        puts "=> Reading page: #{scrape_url}"

        document = open_page(scrape_url) unless page_no == 1
        read_and_save_question_from(document)
      end
    else
      scrape_url = page.to_i == 1 ? url : url + "/page/#{page}/"
      puts "=> Reading page: #{scrape_url}"

      document = open_page(scrape_url)
      read_and_save_question_from(document)
    end
  end

  private

  def open_page(url)
    Nokogiri::HTML(open(url))
  end

  def read_and_save_question_from(page)
    page.css('#content .category-academic-questions').each do |question|
      title   = question.css(".entry-title a").text[0..255]
      url     = question.at_css(".entry-title a")['href']
      content = question.css(".entry-content").children.to_html
      entry   = Question.where(retrieved_from: url).first_or_create!(title: title, content: content)
      puts "* Created question: #{entry.title[0..100]}"
    end
  end
end
