class Admin::TransactionsController < ApplicationController
  before_action :authenticate_admin!

  layout "admin"

  add_breadcrumb "Dashboard", :admin_dashboard_path

  def index
    authorize! :read, Transaction

    @active_section = :transactions
    add_breadcrumb "Transactions", :admin_transactions_path
    respond_to do |format|
      format.html
      format.json { render json: TransactionsDatatable.new(view_context) }
    end
  end

  def show
    @active_section = :transactions
    @transaction = Transaction.friendly.find(params[:id])

    authorize! :read, @transaction

    add_breadcrumb "Transactions", :admin_transactions_path
    add_breadcrumb "##{@transaction.txn_id}", [:admin, @transaction]
  end
end
