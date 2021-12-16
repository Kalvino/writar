class Admin::FaqsController < ApplicationController
  before_action :authenticate_admin!

  layout "admin"

  add_breadcrumb "Dashboard", :admin_dashboard_path

  def index
    authorize! :read, Faq

    @faqs = Faq.order("created_at ASC")

    @active_section = :faqs
    @current_action = :index
    add_breadcrumb "FAQs", :admin_faqs_path
  end


  def new
    authorize! :create, Faq

    @faq = Faq.new

    @active_section = :faqs
    @current_action = :new

    add_breadcrumb "FAQs", :admin_faqs_path
    add_breadcrumb "New", :new_admin_faq_path
  end

  def create
    @faq = Faq.create(faq_params)
    if @faq.save
      redirect_to admin_faqs_path, notice: "FAQ was successfully added"
    else
      render :new
    end
  end

  def edit
    @faq = Faq.find(params[:id])
    authorize! :update, @faq

    @active_section = :faqs
    @current_action = :edit

    add_breadcrumb "FAQs", :admin_faqs_path
    add_breadcrumb "##{@faq.id}", [:admin, @faq]
    add_breadcrumb "Edit", edit_admin_faq_path(@faq)
  end

  def update
    @faq = Faq.find(params[:id])
    authorize! :update, @faq

    if @faq.update(faq_params)
      redirect_to admin_faqs_path, notice: "FAQ was successfully updated"
    else
      render 'edit'
    end
  end

  def destroy
    @faq = Faq.find(params[:id])
    authorize! :destroy, @faq
    @faq.destroy
    redirect_to admin_faqs_path, notice: "FAQ successfully deleted"
  end

  private

  def faq_params
    params.require(:faq).permit(:question, :answer)
  end
end
