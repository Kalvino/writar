class DuplicatesWorker
  include Sidekiq::Worker

  def perform
    dup_logger ||= Logger.new("#{Rails.root}/log/duplicates.log")

    titles_with_multiple = Question.group(:title).having("count(title) > 1").count.keys
    dup_logger.info("Found #{titles_with_multiple.count} duplicates")

    Question.where(title: titles_with_multiple).find_each do |question|
      if question.slug.match(/[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}/)
        if Question.where(content: question.content).any?
          dup_logger.info("Matched question: #{question.slug}")
          dup_logger.info("Deleted question: #{question.title}")
          question.destroy
        else
          dup_logger.info("Question: #{question.title} not deleted as content is unique")
        end
      end
    end
  end
end
