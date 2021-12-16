class Student::OrdersController < ApplicationController
  before_action :authenticate_student!
  before_action :check_order_status, only: [:edit, :update]

  layout "admin"

  add_breadcrumb "Dashboard", :student_dashboard_path

  def index
    add_breadcrumb "Orders", :student_orders_path

    @active_section = :orders
    @current_action = :index

    respond_to do |format|
      format.html
      format.json { render json: OrdersDatatable.new(view_context) }
    end
  end

  def new
    @active_section = :orders
    @current_action = :new
    @order = Order.new

    add_breadcrumb "Orders", :student_orders_path
    add_breadcrumb "New", :new_student_order_path
  end

  def create
    @order = current_student.orders.create(order_params)
    if @order.save
      if params[:files]
        params[:files].each do |file|
          attachment = @order.attachments.create(file: file)
          attachment.save
        end
      end
      NotificationMailer.delay.new_order(@order)
      redirect_to [:student, @order],notice: "Your order was successfully posted. Please proceed to pay for your order by clicking the 'Pay Amount' button"
    else
      render :new
    end
  end

  def show
    @order = current_student.orders.friendly.find(params[:id])
    @messages = @order.messages.order("created_at ASC")
    @message = Message.new
    if @order.status == "pending_payment"
      @paypal = PaypalInvoiceInterface.new(@order.invoice)
      @paypal.express_checkout

      if @paypal.express_checkout_response.success?
        @paypal_url = @paypal.api.express_checkout_url(@paypal.express_checkout_response)
      end
    end
    add_breadcrumb "Orders", :student_orders_path
    add_breadcrumb "##{@order.uid}", student_order_path(@order)
  end

  def update
    @order = current_student.orders.friendly.find(params[:id])
    if @order.update(order_params)
      if params[:files]
        params[:files].each do |file|
          attachment = @order.attachments.create(file: file)
          attachment.save
        end
      end

      respond_to do |format|
        format.json { render json: { status: @order.status  }}
        format.html { redirect_to [:student, @order], notice: "Order successfully updated" }
      end
    else
      render :edit
    end
  end

  def edit
    @order = current_student.orders.friendly.find(params[:id])

    add_breadcrumb "Orders", :student_orders_path
    add_breadcrumb "##{@order.uid}", student_order_path(@order)
    add_breadcrumb "Edit", edit_student_order_path(@order)
  end

  private

  def check_order_status
    @order = current_student.orders.friendly.find(params[:id])
    redirect_to [:student, @order], alert: "You can only edit orders that are pending payment" unless ["pending_quote","pending_payment"].include?(@order.status)
  end


  def order_params
    params.require(:order).permit(:topic, :academic_level, :paper_type, :discipline, :time, :sources,:citation_style,
                                  :hours_to_deadline, :pages, :spacing, :instructions, :status, :uid)
  end
end
