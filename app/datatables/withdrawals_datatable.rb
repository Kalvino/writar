class WithdrawalsDatatable
  delegate :params, :h, :number_to_currency,:link_to, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: withdrawal_count,
        iTotalDisplayRecords: withdrawals.total_entries,
        aaData: data
    }
  end

  private

  def data
    withdrawals.map do |withdrawal|
      [
          withdrawal.created_at.strftime("%d %b %Y at  %I:%M%p"),
          link_to(withdrawal.seller.name, url(withdrawal.seller, :show)),
          number_to_currency(withdrawal.amount)
      ]
    end
  end

  def withdrawals
    @withdrawals ||= fetch_withdrawals
  end

  def fetch_withdrawals
    withdrawals = Withdrawal.order("#{sort_column} #{sort_direction}")
    withdrawals = withdrawals.page(page).per_page(per_page)
    if params[:sSearch].present?
      withdrawals = withdrawals.where("amount = :search", search: "#{params[:sSearch]}")
    end
    if params[:seller_id].present?
      withdrawals = withdrawals.where(seller_id: seller_id)
    end
    withdrawals
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 25
  end

  def sort_column
    columns = %w[created_at seller_id amount]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def url(seller, action)
    if params[:seller_id].present?
      "#"
    else
      case action
        when :show then [:admin, seller]
      end
    end
  end

  def seller_id
    $crypt.decrypt_and_verify(params[:seller_id])
  end

  def withdrawal_count
    if params[:seller_id].present?
      Withdrawal.where(seller_id: seller_id).count
    else
      Withdrawal.count
    end
  end
end
