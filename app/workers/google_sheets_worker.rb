class GoogleSheetsWorker
  include Sidekiq::Worker

  def perform
    SpreadsheetQuestions.new.import
  end
end
