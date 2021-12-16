class Admin::PagesController < ApplicationController
  before_action :authenticate_admin!

  layout "admin"

  add_breadcrumb "Admin", :admin_dashboard_path

  def index
    authorize! :read, Page

    add_breadcrumb "Pages", :admin_pages_path
    @active_section = :pages
    @current_action = :index
    @pages = Page.all
  end

  def new
    authorize! :create, Page

    add_breadcrumb "Pages", :admin_pages_path
    add_breadcrumb "New", :new_admin_page_path

    @page = Page.new
    @active_section = :pages
    @current_action = :new
  end

  def create
    authorize! :create, Page

    @page = Page.create(page_params)
    if @page.save
      redirect_to [:admin, @page], notice: "Page successfully saved"
    else
      render 'new'
    end
  end

  def show
    add_breadcrumb "Pages", :admin_pages_path
    @page = Page.friendly.find(params[:id])
    authorize! :read, @page

    add_breadcrumb @page.name, [:admin, @page]
    @active_section = :pages
    @current_action = :show
  end

  def edit
    add_breadcrumb "Pages", :admin_pages_path
    add_breadcrumb "Edit", :edit_admin_page_path

    @page = Page.friendly.find(params[:id])
    authorize! :update, @page

    @active_section = :pages
    @current_action = :edit
  end

  def update
    @page = Page.friendly.find(params[:id])
    authorize! :update, @page

    if @page.update(page_params)
      redirect_to [:admin, @page], notice: "Page successfully udpated"
    else
      render :edit
    end
  end

  def destroy
    @page = Page.friendly.find(params[:id])
    authorize! :destroy, @page

    @page.destroy
    redirect_to admin_pages_path, notice: "Page deleted"
  end


  private

  def page_params
    params.require(:page).permit(:name, :content)
  end
end
