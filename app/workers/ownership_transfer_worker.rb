class OwnershipTransferWorker
  include Sidekiq::Worker

  def perform(seller_id)
    @logger ||= Logger.new(File.join(Rails.root, 'log', 'receivership.log'))

    @admin = Admin.first
    @seller = Seller.find(seller_id)
    @logger.info("Started essay transfer for user: #{@seller.username}")
    @logger.info("Essays count: #{@seller.essays_count}")
    @logger.info("Essays transferred: #{@seller.essays.map(&:id)}")
    @logger.info("\n")

    @seller.essays.each {|essay| essay.update(owner:  @admin)  }

    # update counter cache column for seller
    Seller.reset_counters(@seller.id, :essays)
  end
end
