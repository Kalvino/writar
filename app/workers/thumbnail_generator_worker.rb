class ThumbnailGeneratorWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :thumbnails

  def perform(essay_id, is_update=false)
    essay = Essay.find(essay_id)

    # delete thumbnails if essay update is set to true
    essay.thumbnails.destroy_all if is_update

    # Download file without reading all of it in mem
    file_ext = essay.document.path.split(".").last
    file_name = "#{SecureRandom.hex(4)}.#{file_ext}"
    file_path = "tmp/#{file_name}"
    IO.copy_stream(open(essay.document.url), file_path)

    # Number of pages
    page_count = Docsplit.extract_length(file_path)
    pages = (1..page_count).first(10)

    # Generate preview for first page
    Docsplit.extract_images(file_path, format: :png, pages: pages, output: "tmp/#{essay.id}")

    thumbnails = Dir["tmp/#{essay.id}/*.png"]
    thumbnails.each do |thumbnail|
      page = thumbnail.match(/_([0-9]+).png/)[1]
      essay.thumbnails.create(file: File.open(thumbnail), page_no: page)
    end

    # Delete file
    FileUtils.rm(file_path)

    # Delete folder
    FileUtils.rm_rf("tmp/#{essay.id}")
  end
end