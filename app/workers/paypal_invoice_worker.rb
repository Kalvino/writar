class PaypalInvoiceWorker
  include Sidekiq::Worker

  sidekiq_options :queue => :paypal

  def perform(invoice_id)
    invoice = Invoice.find(invoice_id)

    paypal = PaypalInvoiceInterface.new(invoice)
    paypal.do_express_checkout
  end
end
