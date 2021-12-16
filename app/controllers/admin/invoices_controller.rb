class Admin::InvoicesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_order

  layout "admin"

  def new
    authorize! :create, Invoice

    @invoice = Invoice.new
  end

  def create
    authorize! :create, Invoice

    @invoice = @order.create_invoice(invoice_params)
    if @invoice.save
      NotificationMailer.delay.send_invoice(@invoice)
      redirect_to [:admin, @order], notice: "Quote successfully sent"
    else
      render :new
    end
  end

  def edit
    add_breadcrumb "Orders", :admin_orders_path
    add_breadcrumb "##{@order.uid}", admin_order_path(@order)
    add_breadcrumb "Quote", edit_admin_order_invoices_path(@order)

    @invoice = @order.invoice
    authorize! :update, @invoice
  end

  def update
    @invoice = @order.invoice
    authorize! :update, @invoice

    if @invoice.update(invoice_params)
      NotificationMailer.delay.update_invoice(@invoice)

      redirect_to [:admin, @order], notice: "Quote successfully updated"
    else
      render :edit
    end
  end

  private

  def set_order
    @order = Order.friendly.find(params[:order_id])
  end

  def invoice_params
    params.require(:invoice).permit(:amount, :message)
  end
end
