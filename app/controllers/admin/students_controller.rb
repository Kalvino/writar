class Admin::StudentsController < ApplicationController
  before_action :authenticate_admin!

  layout "admin"

  add_breadcrumb "Admin", :admin_dashboard_path

  def index
    authorize! :read, Student

    @active_section = :students
    add_breadcrumb "Students", :admin_students_path

    @students_today       = Student.today.count
    @students_this_week   = Student.this_week.count
    @students_this_month  = Student.this_month.count
    @students_this_year   = Student.this_year.count

    respond_to do |format|
      format.html
      format.json { render json: StudentsDatatable.new(view_context) }
    end
  end

  def show
    @student = Student.friendly.find(params[:id])
    authorize! :read, @student
    
    @orders = @student.orders
    @active_section = :students

    add_breadcrumb "Students", :admin_students_path
    add_breadcrumb @student.name, [:admin, @student]
  end
end
