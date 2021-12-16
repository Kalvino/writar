class SitemapImportWorker
  include Sidekiq::Worker
  sidekiq_options queue: :scrapers

  def perform(url, klass)
    klass.constantize.read_and_save_question_from(url)
  end
end
