class Marketplace::SellersController < ApplicationController
  before_action :authenticate_seller!

  layout "marketplace"

  def show
    @seller = current_seller
    @published_essays = @seller.essays.approved.count
    @pending_essays = @seller.essays.pending.count
    @active_section = :profile
  end

  def update
    @seller = current_seller
    @seller.update(seller_params)
    @response = @seller.save ? @response = { updated: "ok", email: @seller.paypal_email, msg: "Paypal email successfully set" } : { updated: "false", errors: @seller.errors.full_messages }
    respond_to do |format|
      format.json { render json: @response }
      format.html { redirect_to :back }
    end
  end

  private

  def seller_params
    params.require(:seller).permit(:paypal_email)
  end
end
