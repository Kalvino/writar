class TransactionsDatatable
  delegate :params, :h, :link_to, :content_tag, :truncate,:concat,:number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: transactions_count,
        iTotalDisplayRecords: transactions.total_entries,
        aaData: data
    }
  end

  private

  def data
    transactions.map do |transaction|
      [
          transaction.created_at.strftime("%d %b %Y"),
          transaction.txn_type,
          number_to_currency(transaction.amount),
          number_to_currency(transaction.balance_before),
          number_to_currency(transaction.balance_after),
          render_row(transaction),
          link_to(transaction.txn_id, url(transaction, :show))
      ]
    end
  end

  def transactions
    @transactions ||= fetch_transactions
  end

  def fetch_transactions
    transactions = Transaction.includes(:owner).order("#{sort_column} #{sort_direction}")
    transactions = transactions.page(page).per_page(per_page)
    if params[:sSearch].present?
      transactions = transactions.where("txn_type iLike :search OR txn_id iLike :search OR description iLike :search", search: "%#{params[:sSearch]}%")
    end
    if params[:seller_id].present?
      transactions = transactions.where(owner_id: seller_id, owner_type: "Seller")
    end
    if params[:writer_id].present?
      transactions = transactions.where(owner_id: writer_id, owner_type: "Writer")
    end
    transactions
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 25
  end

  def sort_column
    columns = %w[created_at txn_type amount balance_before balance_after description txn_id]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def url(transaction, action)
    if params[:seller_id].present? && !params[:is_admin].present?
      case action
        when :show then [:marketplace, transaction]
      end
    else
      case action
        when :show then [:admin, transaction]
      end
    end
  end

  def render_row(transaction)
    if params[:seller_id].present? && params[:is_admin].present?
      truncate(transaction.description, length: 30)
    elsif params[:writer_id].present? && params[:is_admin].present?
      truncate(transaction.description, length: 30)
    elsif params[:is_admin].present?
      link_to(transaction.owner.first_name.titleize, [:admin, transaction.owner])
    else
      truncate(transaction.description, length: 30)
    end
  end

  def seller_id
    $crypt.decrypt_and_verify(params[:seller_id])
  end

  def writer_id
    $crypt.decrypt_and_verify(params[:writer_id])
  end

  def transactions_count
    if params[:is_admin].present?
      Transaction.count
    elsif params[:seller_id].present?
      Transaction.where(owner_type: "Seller", owner_id: seller_id).count
    elsif params[:writer_id].present?
      Transaction.where(owner_type: "Writer", owner_id: writer_id).count
    end
  end
end
