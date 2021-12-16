class Student::StudentsController < ApplicationController
  before_action :authenticate_student!

  layout "admin"

  def dashboard
    add_breadcrumb "Student", :student_dashboard_path
    add_breadcrumb "Dashboard", :student_dashboard_path

    @active_section = :dashboard

    @recent_orders = current_student.orders.order("created_at DESC").limit(5)
    @in_progress = current_student.orders.in_progress.count
    @pending_payment = current_student.orders.pending_payment.count
    @completed = current_student.orders.completed.count
    @total = current_student.orders.count
  end

  def how_it_works
    add_breadcrumb "Student", :student_dashboard_path
    add_breadcrumb "How it Works", :student_how_it_works_path
    @active_section = :how_it_works
  end

  def show
    @student = current_student
    @current_action = :show
    @active_section = :profile
    
    add_breadcrumb "Student", :student_dashboard_path
    add_breadcrumb "Profile", :student_profile_path
  end
  
  def update
    @student = current_student
    if @student.update(student_params)
      redirect_to student_profile_path, notice: "Profile successfully updated"
    else
      redirect_to student_profile_path, alert: @student.errors.full_messages.join(",")
    end
  end

  def student_params
    params.require(:student).permit(:first_name, :last_name, :email, :timezone)
  end
end
