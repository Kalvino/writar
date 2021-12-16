class PaypalWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :paypal

  def perform(essay_id, key)
    @essay = Essay.find(essay_id)

    @paypal = PaypalInterface.new(@essay)
    @response = @paypal.do_express_checkout(key)

    if @response.kind_of?(String)
      @record = JSON.parse $redis.get(@response)
      @purchase = @essay.purchases.create!(payment_token: @record["payment_token"], payer_id: @record["payer_id"], txn_id: @record["transaction_id"])

      # CREATE TRANSACTIONS
      @essay.owner.transactions.create(amount: @essay.price, purchase_id: @purchase.id, txn_type: "Paper Purchase", description: "Paper purchased: #{@essay.title}")
      unless @essay.owner.kind_of?(Admin)
        transaction = @essay.owner.transactions.create(amount: @essay.service_fee*-1, txn_type: "Service Fee", description: "Platform Service fee")
        NotificationMailer.purchased_paper(@essay, transaction).deliver
      end
    end
  end
end
