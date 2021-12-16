class Admin::SellersController < ApplicationController
  before_action :authenticate_admin!

  layout "admin"

  add_breadcrumb "Admin", :admin_dashboard_path

  def index
    authorize! :read, Seller

    @sellers_today       = Seller.today.count
    @sellers_this_week   = Seller.this_week.count
    @sellers_this_month  = Seller.this_month.count
    @sellers_this_year   = Seller.this_year.count

    @active_section = :sellers
    add_breadcrumb "Sellers", :admin_sellers_path

    respond_to do |format|
      format.html
      format.json { render json: SellersDatatable.new(view_context) }
    end
  end

  def show
    authorize! :read, Seller

    @seller = Seller.friendly.find(params[:id])
    @essays = @seller.essays
    @published_essays = @essays.approved
    @pending_essays = @essays.pending
    @uploads = @essays.past_7_days
    @active_section = :sellers

    add_breadcrumb "Sellers", :admin_sellers_path
    add_breadcrumb @seller.name, [:admin, @seller]
  end

  def transfer_ownership
    @seller = Seller.friendly.find(params[:seller_id])
    authorize! :take_ownership, @seller

    OwnershipTransferWorker.perform_async(@seller.id)
    render json: { message: "Receivership process has began. Transfer should be complete in less than a minute" }
  end

end
