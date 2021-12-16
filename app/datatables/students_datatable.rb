class StudentsDatatable
  delegate :params, :h, :link_to, :can?, :content_tag, :concat, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Student.count,
        iTotalDisplayRecords: students.total_entries,
        aaData: data
    }
  end

  private

  def data
    students.map do |student|
      [
          student.first_name.titleize,
          student.last_name.present? ? student.last_name.titleize : "-",
          student.email,
          ISO3166::Country.new(student.country).name,
          student.orders_count,
          student.created_at.strftime("%d %b %Y"),
          content_tag(:div, class: "btn-group", role: "group") do
            concat(link_to("<i class='fa fa-eye'></i> View".html_safe, [:admin, student], class: "btn-default btn-white btn btn-xs")) if can? :read, student
            concat(link_to("<i class='fa fa-pencil'></i> Edit".html_safe, "#", class: "btn-default btn-white btn btn btn-xs")) if can? :update, student
          end
      ]
    end
  end

  def students
    @students ||= fetch_students
  end

  def fetch_students
    students = Student.order("#{sort_column} #{sort_direction}")
    students = students.page(page).per_page(per_page)
    if params[:sSearch].present?
      students = students.where("first_name iLike :search OR last_name iLike :search OR email iLike :search", search: "%#{params[:sSearch]}%")
    end
    students
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 25
  end

  def sort_column
    columns = %w[first_name last_name email country orders_count created_at]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
