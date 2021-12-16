class Admin::RedemptionsController < ApplicationController
  before_action :authenticate_admin!

  def index
    authorize! :read, Redemption

    respond_to do |format|
      format.json { render json: RedemptionsDatatable.new(view_context) }
    end
  end
end
