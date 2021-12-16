require 'paypal-sdk-merchant'

class PaypalInterface
  attr_reader :api, :express_checkout_response

  PAYPAL_RETURN_URL = Rails.application.routes.url_helpers.paid_essays_url(host: ENV["HOST"])
  PAYPAL_CANCEL_URL = Rails.application.routes.url_helpers.revoked_essays_url(host: ENV["HOST"])
  PAYPAL_NOTIFY_URL = Rails.application.routes.url_helpers.ipn_essays_url(host: ENV["HOST"])

  def initialize(essay)
    @api = PayPal::SDK::Merchant::API.new
    @essay = essay
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
                            value: @essay.price
                        },
                        ItemTotal: {
                            currencyID: "USD",
                            value: @essay.price
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
                                Name: "Purchase: #{@essay.title}",
                                Quantity: 1,
                                Amount: {
                                    currencyID: "USD",
                                    value: @essay.price
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
      key   = Digest::MD5.hexdigest(@express_checkout_response.Token)
      value = { payment_token: @express_checkout_response.Token }
      $redis.setex(key,7200,value.to_json)
    else
      SlackBot.notify("Paypal error during express checkout","Paypal Error", @express_checkout_response.Errors)
    end
  end

  def do_express_checkout(key)
    @record = JSON.parse $redis.get(key)
    @do_express_checkout_payment = @api.build_do_express_checkout_payment(
        {
            DoExpressCheckoutPaymentRequestDetails: {
                PaymentAction: "Sale",
                Token: @record["payment_token"],
                PayerID: @record["payer_id"],
                PaymentDetails: [
                    {
                        OrderTotal: {
                            currencyID: "USD",
                            value: @essay.price
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
      @record[:transaction_id] = details.PaymentInfo[0].TransactionID
      $redis.set(key, @record.to_json)
      return key
    else
      @errors = @do_express_checkout_payment_response.Errors
      SlackBot.notify("Paypal error during express checkout","Paypal Error", @errors)
      return @errors # => Array
    end
  end
end
