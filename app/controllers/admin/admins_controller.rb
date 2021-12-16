class Admin::AdminsController < ApplicationController
  before_action :authenticate_admin!
  layout "admin"

  add_breadcrumb "Admin", :admin_dashboard_path

  def index
    authorize! :read, Admin

    @admins = Admin.all
    @active_section = :admins

    add_breadcrumb "Admins", :admin_admins_path
  end

  def new
    authorize! :create, Admin

    @admin = Admin.new
    @active_section = :admins

    add_breadcrumb "Admins", :admin_admins_path
    add_breadcrumb "New", :new_admin_admin_path
  end

  def create
    authorize! :create, Admin
    @admin = Admin.create(admin_params.merge(role: admin_params[:role].to_i))
    if @admin.save
      redirect_to admin_admins_path, notice: "Admin successfully added"
    else
      render 'new'
    end
  end

  def show
    @admin = Admin.friendly.find(params[:id])
    authorize! :read, @admin
    @essays = @admin.essays
    @papers_today = @essays.today.count
    @papers_this_week = @essays.this_week.count
    @papers_this_month = @essays.this_month.count
    @papers_this_year = @essays.this_year.count
    @papers_last_week = @essays.between(1.week.ago.beginning_of_week,1.week.ago.end_of_week)

    add_breadcrumb "Admins", :admin_admins_path
    add_breadcrumb @admin.name, admin_admin_path(@admin)
  end

  def edit
    @admin = Admin.friendly.find(params[:id])
    authorize! :update, @admin
    @active_section = :admins

    add_breadcrumb "Admins", :admin_admins_path
    add_breadcrumb "Edit", edit_admin_admin_path(@admin)
  end

  def update
    @admin = Admin.friendly.find(params[:id])
    authorize! :update, @admin
    if @admin.update(admin_params.merge(role: admin_params[:role].to_i))
      redirect_to admin_admins_path, notice: "Admin details successfully updated"
    else
      render 'edit'
    end
  end


  def destroy
    @admin = Admin.friendly.find(params[:id])
    authorize! :destroy, @admin
    @admin.destroy
    redirect_to admin_admins_path, notice: "Admin was successfully deleted"
  end

  private

  def admin_params
    params.require(:admin).permit(:first_name, :last_name, :email, :role, :timezone, :password, :password_confirmation)
  end
end
