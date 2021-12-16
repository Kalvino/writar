class Student::FaqsController < ApplicationController
  before_action :authenticate_student!

  layout "admin"

  def index
    add_breadcrumb "Student", :student_dashboard_path
    add_breadcrumb "Dashboard", :student_dashboard_path
    add_breadcrumb "FAQs", :student_faqs_path

    @active_section = :faqs
    @faqs = Faq.order("created_at ASC")
  end
end
