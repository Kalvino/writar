class Admin::CouponsController < ApplicationController
  before_action :authenticate_admin!

  layout "admin"

  add_breadcrumb "Dashboard", :admin_dashboard_path

  def index
    authorize! :read, Coupon

    add_breadcrumb "Coupons", :admin_coupons_path
    @coupons = Coupon.order("created_at DESC")
  end

  def new
    authorize! :create, Coupon

    add_breadcrumb "Coupons", :admin_coupons_path
    add_breadcrumb "New", :new_admin_coupon_path

    @coupon = Coupon.new(code: SecureRandom.hex(4).upcase)
  end

  def show
    @coupon = Coupon.find(params[:id])
    authorize! :read, @coupon

    add_breadcrumb "Coupons", :admin_coupons_path
    add_breadcrumb @coupon.code, [:admin, @coupon]
  end

  def create
    authorize! :create, Coupon

    @coupon = Coupon.create(coupon_params)
    if @coupon.save
      redirect_to admin_coupons_path, notice: "Coupon was successfully created"
    else
      render :new
    end
  end

  def edit
    @coupon = Coupon.find(params[:id])
    authorize! :update, @coupon

    add_breadcrumb "Coupons", :admin_coupons_path
    add_breadcrumb @coupon.code, [:admin, @coupon]
    add_breadcrumb "Edit", admin_coupon_path(@coupon)
  end

  def update
    @coupon = Coupon.find(params[:id])
    authorize! :update, @coupon

    @coupon.update(coupon_params)
    if @coupon.save
      redirect_to admin_coupons_path, notice: "Coupon was successfully updated"
    else
      render :edit
    end
  end

  def destroy
    @coupon = Coupon.find(params[:id])
    authorize! :destroy, @coupon

    redirect_to :back
  end


  private

  def coupon_params
    params.require(:coupon).permit(:code,:description,:amount,:coupon_type,:valid_from,:valid_until)
  end
end
