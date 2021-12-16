class MarketplaceController < ApplicationController
  before_action :authenticate_seller!

  layout "marketplace"

  def dashboard
    @active_section = :dashboard
    @essays = current_seller.essays.recent
    @published_essays = @essays.approved.count
    @downloads = @essays.sum(:download_count)
    @pending_essays = @essays.pending.count
  end
end
