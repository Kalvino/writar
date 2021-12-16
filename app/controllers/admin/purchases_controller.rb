class Admin::PurchasesController < ApplicationController
  before_action :authenticate_admin!

  layout "admin"

  add_breadcrumb "Admin", :admin_dashboard_path

  def index
    authorize! :read, Purchase

    add_breadcrumb "Purchases", :admin_purchases_path
    @active_section = :purchases
    respond_to do |format|
      format.html
      format.json { render json: PurchasesDatatable.new(view_context) }
    end
  end

  def show
    authorize! :read, Purchase
    @active_section = :purchases
    @purchase = Purchase.friendly.find(params[:id])
    @essay = @purchase.essay

    add_breadcrumb "Purchases", :admin_purchases_path
    add_breadcrumb @purchase.txn_id, admin_purchase_path(@purchase)
  end

  def heat_map
    @data ||= Purchase.year(Date.today.year).group_by(&:residence_country).each_with_object({}) do |(country_code, purchases), data|
      data[country_code] = purchases.count
    end
    render json: @data
  end
end
