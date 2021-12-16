module MarketplaceHelper
  def label_for(status)
    case status
      when "approved" then '<span class="label label-success">Approved</span>'
      when "pending" then '<span class="label label-warning">Pending</span>'
      when "denied" then '<span class="label label-danger">Denied</span>'
    end.html_safe
  end
end
