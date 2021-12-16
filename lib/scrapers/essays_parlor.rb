require 'open-uri'

class EssaysParlor

  BASE_URL = "https://essaysparlor.com"

  class << self
    def scrape
      (2..15).each do |index|
        url = BASE_URL + "/sitemap-#{index}.xml"
        puts "=> Reading Sitemap: #{url}\n"
        hash = Hash.from_xml(open(url))
        hash["urlset"]["url"].each_with_index do |entry,index|
          time = (index + 1).seconds
          puts "=> Reading page: #{entry["loc"]}"
          SitemapImportWorker.perform_in(time, entry["loc"], "EssaysParlor")
        end
      end
    end

    def read_and_save_question_from(url)
      page    = Nokogiri::HTML(open(url))
      title   = page.at_css("h2.mkdf-post-title").text.strip
      content = page.css(".mkdf-post-text p").to_html.gsub("?", " ")

      begin
        entry   = Question.where(retrieved_from: url).first_or_create!(title: title, content: content)
        puts "\t* Created question: #{entry.title[0..100]}"
      rescue ActiveRecord::RecordInvalid => e
        puts e.message
      end
    end
  end
end
