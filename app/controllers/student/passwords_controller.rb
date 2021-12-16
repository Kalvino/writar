class Student::PasswordsController < ApplicationController
  before_action :authenticate_student!

  layout "admin"

  def edit
    @student = current_student
    @current_action = :edit
    @active_section = :profile
    add_breadcrumb "Profile", :student_profile_path
    add_breadcrumb "Edit", edit_student_pass_path
  end

  def update
    @student = current_student

    if @student.update_with_password(student_params)
      # Sign in the student by passing validation in case his password changed
      flash[:notice] = "Your password was successfully updated"
      sign_in @student, :bypass => true
      redirect_to student_profile_path
    else
      render 'edit'
    end
  end

  private

  def student_params
    params.required(:student).permit(:password, :password_confirmation, :current_password)
  end
end
