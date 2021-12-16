class ProessayWriting
  attr_reader :sitemap_id, :sitemap_url, :logger

  BASE_URL = "http://proessaywriting.net/blog"

  def initialize(sitemap_id)
    @sitemap_id   = sitemap_id
    @sitemap_url  = BASE_URL + "/sitemap_post_#{sitemap_id}.xml.gz"
    @logger       = Logger.new("#{Rails.root}/log/proessaywriting.log")
  end

  def import
    sitemap = download_and_uncompress(sitemap_url)
    hash = Hash.from_xml(File.read(sitemap))

    hash["urlset"]["url"].each_with_index do |entry,index|
      time = rand(1..(index+1)).seconds
      logger.info("Reading page: #{entry["loc"]}")
      SitemapImportWorker.perform_in(time, entry["loc"], self.class.to_s)
    end

    # Delete file. Done Reading
    FileUtils.rm(sitemap)
    logger.info("Deleting sitemap: #{sitemap}")
  end

  class << self
    def read_and_save_question_from(url)
      logger ||= Logger.new("#{Rails.root}/log/proessaywriting.log")

      slug      = url.split("/").last
      question  = Question.where("retrieved_from like ?", "%#{slug}%")
      return if question.any?

      begin
        html    = Net::HTTP.get(URI.parse(url))
        page    = Nokogiri::HTML(html)
        title   = page.at_css("h2.entry-title").text.strip
        content = page.css(".entry-content").to_html.gsub(/<a style=".*;" href=".*">Click here to Order .*<\/a>/,'')
        length  = Nokogiri::HTML(content).text.gsub(/\r|\t|\n/,'').length
        return if length < 20

        begin
          entry   = Question.where(retrieved_from: url).first_or_create!(title: title, content: content)
          logger.info("Created question: #{entry.title[0..100]}")
        rescue ActiveRecord::RecordInvalid => e
          logger.error(e.message)
        end
      rescue Net::ReadTimeout => e
        sleep(5.seconds)
        retry
      rescue NoMethodError => e
        logger.error(e.message)
        SitemapImportWorker.perform_in(rand(60..3600).seconds, url, "ProessayWriting")
      end
    end
  end

  private

  def download_and_uncompress(sitemap_url)
    uncompressed_sitemap  = "tmp/sitemap_#{sitemap_id}.xml"
    compressed_sitemap    = "tmp/sitemap_#{sitemap_id}.xml.gz"

    download(sitemap_url, compressed_sitemap)

    logger.info("Uncompressing file: #{compressed_sitemap}")

    Zlib::GzipReader.open(compressed_sitemap) do | input_stream |
      File.open(uncompressed_sitemap, "w") do |output_stream|
        IO.copy_stream(input_stream, output_stream)
      end
    end

    logger.info("Sucessfully uncompressed file")

    # Delete  compressed file
    FileUtils.rm(compressed_sitemap)

    logger.info("Deleting compressed file: #{compressed_sitemap}")

    uncompressed_sitemap
  end

  def download(url, path)
    logger.info("Downloading file from: #{url}")
    File.open(path, "w") do |f|
      IO.copy_stream(open(url), f)
    end
  end
end
