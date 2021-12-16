class Marketplace::WithdrawalsController < ApplicationController
  before_action :authenticate_seller!

  layout "marketplace"

  def index
    @active_section = :bank
    respond_to do |format|
      format.html
      format.json { render json: WithdrawalsDatatable.new(view_context) }
    end
  end

  def new
    @active_section = :bank
    @withdrawal = Withdrawal.new
    @recent_withdrawal = current_seller.withdrawals.recent.first.amount if current_seller.withdrawals.any?
  end

  def create
    @seller = current_seller
    @withdrawal = @seller.withdrawals.create(amount: @seller.balance)
    if @withdrawal.save
      redirect_to marketplace_withdrawals_path, notice: "Withdrawal request successfully received"
    else
      render 'new'
    end
  end
end
