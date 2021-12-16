require 'paypal-sdk-merchant'

class PaypalInvoiceInterface
  attr_reader :api, :express_checkout_response

  PAYPAL_RETURN_URL = Rails.application.routes.url_helpers.paid_invoices_url(host: ENV["HOST"])
  PAYPAL_CANCEL_URL = Rails.application.routes.url_helpers.revoked_invoices_url(host: ENV["HOST"])
  PAYPAL_NOTIFY_URL = Rails.application.routes.url_helpers.ipn_invoices_url(host: ENV["HOST"])

  def initialize(invoice)
    @api = PayPal::SDK::Merchant::API.new
    @invoice = invoice
  end

  def express_checkout
    @set_express_checkout = @api.build_set_express_checkout(
        {
            SetExpressCheckoutRequestDetails: {
                ReturnURL: PAYPAL_RETURN_URL,
                CancelURL: PAYPAL_CANCEL_URL,
                NoShipping: 1,
                PaymentDetails: [
                    {
                        NotifyURL: PAYPAL_NOTIFY_URL,
                        OrderTotal: {
                            currencyID: "USD",
                            value: @invoice.amount
                        },
                        ItemTotal: {
                            currencyID: "USD",
                            value: @invoice.amount
                        },
                        ShippingTotal: {
                            currencyID: "USD",
                            value: "0"
                        },
                        TaxTotal: {
                            currencyID: "USD",
                            value: "0"
                        },
                        PaymentDetailsItem: [
                            {
                                Name: "Payment for order ##{@invoice.order.uid}",
                                Quantity: 1,
                                Amount: {
                                    currencyID: "USD",
                                    value: @invoice.amount
                                },
                                ItemCategory: "Physical"
                            }],
                        PaymentAction: "Sale"
                    }
                ]
            }
        }
    )

    # Make API call & get response
    @express_checkout_response = @api.set_express_checkout(@set_express_checkout)

    # Access Response
    if @express_checkout_response.success?
      @invoice.set_payment_token(@express_checkout_response.Token)
    else
      SlackBot.notify("Paypal error during express checkout","Paypal Error", @express_checkout_response.Errors)
    end
  end

  def do_express_checkout
    @do_express_checkout_payment = @api.build_do_express_checkout_payment(
        {
            DoExpressCheckoutPaymentRequestDetails: {
                PaymentAction: "Sale",
                Token: @invoice.payment_token,
                PayerID: @invoice.payer_id,
                PaymentDetails: [
                    {
                        OrderTotal: {
                            currencyID: "USD",
                            value: @invoice.amount
                        },
                        NotifyURL: PAYPAL_NOTIFY_URL
                    }
                ]
            }
        }
    )

    # Make API call & get response
    @do_express_checkout_payment_response = @api.do_express_checkout_payment(@do_express_checkout_payment)

    # Access Response
    if @do_express_checkout_payment_response.success?
      details = @do_express_checkout_payment_response.DoExpressCheckoutPaymentResponseDetails
      @invoice.update(txn_id: details.PaymentInfo[0].TransactionID)
    else
      @errors = @do_express_checkout_payment_response.Errors
      SlackBot.notify("Paypal error during express checkout","Paypal Error", @errors)
    end
  end
end
