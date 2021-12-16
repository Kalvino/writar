class QuestionsDatatable
  delegate :params, :h, :link_to, :truncate, :can?, :content_tag, :concat, :strip_tags, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Question.count,
        iTotalDisplayRecords: questions.total_entries,
        aaData: data
    }
  end

  private

  def data
    questions.map do |question|
      [
          truncate(question.title.titleize, length: 80),
          label_for(question.status),
          question.created_at.strftime("%d %b %Y"),
          content_tag(:div, class: "btn-group", role: "group") do
            concat(link_to("<i class='fa fa-eye'></i> View".html_safe, Rails.application.routes.url_helpers.admin_question_path(question), class: "btn-default btn-white btn btn-xs")) if can? :read, question
            concat(link_to("<i class='fa fa-pencil'></i> Edit".html_safe, Rails.application.routes.url_helpers.edit_admin_question_path(question), class: "btn-default btn-white btn btn btn-xs")) if can? :update, question
            concat(link_to("<i class='fa fa-trash'></i> Delete".html_safe, Rails.application.routes.url_helpers.admin_question_path(question), method: :delete,  data: { confirm: "Are you sure you want to delete this question?"}, class: "btn-default btn-danger btn btn btn-xs")) if can? :destroy, question
          end
      ]
    end
  end

  def questions
    @questions ||= fetch_questions
  end

  def fetch_questions
    questions = Question.order("#{sort_column} #{sort_direction}")
    questions = questions.page(page).per_page(per_page)
    if params[:sSearch].present?
      questions = questions.where("title iLike :search", search: "%#{params[:sSearch]}%")
    end
    if params[:status].present?
      questions = questions.send(params[:status])
    end
    questions
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 25
  end

  def sort_column
    columns = %w[title, content created_at]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def label_for(status)
    case status
      when "approved" then '<span class="label label-success">Approved</span>'
      when "pending" then '<span class="label label-warning">Pending</span>'
      when "denied" then '<span class="label label-danger">Denied</span>'
    end
  end
end
