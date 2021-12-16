class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

  layout "admin"

  add_breadcrumb "Dashboard", :admin_dashboard_path

  def index
    add_breadcrumb "Orders", :admin_orders_path
    authorize! :read, Order

    @active_section = :orders
    @current_action = :index

    @orders_today = Order.today.count
    @orders_this_week = Order.this_week.count
    @orders_this_month = Order.this_month.count
    @orders_this_year = Order.this_year.count

    respond_to do |format|
      format.html
      format.json { render json: OrdersDatatable.new(view_context) }
    end
  end

  def show
    @order = Order.friendly.find(params[:id])
    authorize! :read, @order

    @messages = @order.messages.order("created_at ASC")
    @message = Message.new
    add_breadcrumb "Orders", :admin_orders_path
    add_breadcrumb "##{@order.uid}", student_order_path(@order)
  end

  def edit
    @order = Order.friendly.find(params[:id])
    authorize! :update, @order

    add_breadcrumb "Orders", :admin_orders_path
    add_breadcrumb "##{@order.uid}", admin_order_path(@order)
    add_breadcrumb "Edit", edit_admin_order_path(@order)
  end

  def update
    @order = Order.friendly.find(params[:id])
    authorize! :update, @order


    if @order.update(order_params)
      if params[:files]
        params[:files].each do |file|
          attachment = @order.attachments.create(file: file)
          attachment.save
        end
      end

      message = order_params[:assigned_to_id].present? ? "Order ##{@order.uid} successfully assigned to #{@order.assigned_to.name}" : "Order was successfully updated"

      respond_to do |format|
        format.json { render json: { message: "This order has been successfully marked as: #{@order.status}" }}
        format.html { redirect_to [:admin, @order], notice: message }
      end
    end
  end

  def destroy
    @order = Order.friendly.find(params[:id])
    authorize! :destroy, @order
    @order.destroy
    redirect_to admin_orders_path, notice: "Order successfully deleted"
  end

  private

  def order_params
    params.require(:order).permit(:topic, :academic_level, :paper_type, :discipline, :time, :sources,:citation_style,
                                  :due_at, :pages, :spacing, :instructions, :status, :assigned_to_id)
  end
end
