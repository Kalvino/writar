class AdminController < ApplicationController
  before_action :authenticate_admin!

  add_breadcrumb "Admin", "#"

  def dashboard
    add_breadcrumb "Dashbaord", :admin_dashboard_path
    @essays = Essay.this_year.count
    @sales = Transaction.this_year.revenue
    @sellers = Seller.this_year.count
    @students = Student.this_year.count
    @downloads = Purchase.this_year.count
    @purchases = Purchase.order("created_at DESC").limit(10)
    @papers = Essay.recent.limit(10)

    @orders_today = Order.today.count
    @orders_this_week = Order.this_week.count
    @orders_this_month = Order.this_month.count
    @orders_this_year = Order.this_year.count
    @order_revenue = Invoice.this_month.revenue
    @order_annual_revenue = Invoice.this_year.revenue
  end

  def dashboard_purchases
    @data ||=  PurchasesChart.new(params[:year]).draw
    render json: @data
  end

  def dashboard_orders
    @data ||=  OrdersChart.new(params[:year]).draw
    render json: @data
  end

  def paper_statuses
    @data ||= PaperStatusesChart.new(Date.today.year).draw
    render json: @data
  end

  def question_statuses
    @data ||= QuestionStatusesChart.new(Date.today.year).draw
    render json: @data
  end
end
