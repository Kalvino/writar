class Admin::WithdrawalsController < ApplicationController
  before_action :authenticate_admin!

  layout "admin"

  add_breadcrumb "Dashboard", :admin_dashboard_path

  def index
    authorize! :read, Withdrawal
    @active_section = :withdrawals


    add_breadcrumb "Withdrawals", admin_withdrawals_path

    respond_to do |format|
      format.html
      format.json { render json: WithdrawalsDatatable.new(view_context) }
    end
  end
end
