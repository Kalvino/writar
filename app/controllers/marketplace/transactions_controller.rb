class Marketplace::TransactionsController < ApplicationController
  before_action :authenticate_seller!

  layout "marketplace"

  def index
    @active_section = :bank
    respond_to do |format|
      format.html
      format.json { render json: TransactionsDatatable.new(view_context) }
    end
  end

  def show
    @active_section = :bank
    @transaction = Transaction.friendly.find(params[:id])
  end
end
