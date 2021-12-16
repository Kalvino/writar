class InvoicesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:ipn]

  def paid
    @invoice = Invoice.find_by_payment_token(params[:token])
    @invoice.update(payer_id: params[:PayerID])
    @order = @invoice.order
    @order.update(status: "in_progress")
    PaypalInvoiceWorker.perform_async(@invoice.id)
    redirect_to [:student, @invoice.order], notice: "Thank you, we've received your payment. Our writer will now commence on your assignment"
  end

  def revoked
    @invoice = Invoice.find_by_payment_token(params[:token])
    redirect_to [:student, @invoice.order], alert: "Ooops, We did not receive your payment"
  end

  def ipn
    if params[:parent_txn_id]
      invoice = Invoice.find_by_txn_id(params[:parent_txn_id])
      if invoice.nil?
        SlackBot.notify("Cannot find invoice with txn_id #{params[:parent_txn_id]}","txn not found error","Invoice record is nil")
      else
        invoice.update(ipn_params.except(:parent_txn_id))
      end
    else
      invoice = Invoice.find_by_txn_id(params[:txn_id])
      if invoice.nil?
        SlackBot.notify("Cannot find invoice with txn_id #{params[:txn_id]}","txn not found error","Invoice record is nil")
      else
        invoice.update(ipn_params)
        NotificationMailer.delay.payment_received(invoice.order)
      end
    end

    render json: {}, status: :ok
  end

  private

  def ipn_params
    params.permit(:first_name, :last_name, :payer_email, :payer_id, :txn_id, :residence_country, :payment_status,
                  :payment_date, :payment_token, :mc_fee, :mc_gross, :verify_sign)
  end
end
