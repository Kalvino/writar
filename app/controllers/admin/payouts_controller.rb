class Admin::PayoutsController < ApplicationController
  before_action :authenticate_admin!

  layout "admin"
  
  def create
    @writer = Writer.find(payout_params[:user_id])
    @payout = @writer.payouts.create(amount: @writer.balance)
    if @payout.save
      redirect_to [:admin, @writer], notice: "Successfully paid #{@writer.first_name} $#{@payout.amount}"
    else
      redirect_to [:admin, @writer], alert: @payout.errors.full_messages.join(",")
    end
  end

  private

  def payout_params
    params.require(:payout).permit(:user_id)
  end
end
