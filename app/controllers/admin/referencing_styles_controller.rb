class Admin::ReferencingStylesController < ApplicationController
  before_action :authenticate_admin!

  layout "admin"

  add_breadcrumb "Admin", :admin_dashboard_path

  def index
    add_breadcrumb "Styles", admin_referencing_styles_path

    @styles = ReferencingStyle.all
    @active_section = :referencing_styles
    @current_action = :index
  end

  def new
    authorize! :create, ReferencingStyle

    @style = ReferencingStyle.new
    @active_section = :referencing_styles
    @current_action = :new

    add_breadcrumb "Styles", admin_referencing_styles_path
    add_breadcrumb "New", new_admin_referencing_style_path
  end

  def create
    authorize! :create, ReferencingStyle
    @style = ReferencingStyle.create(referencing_style_params)
    if @style.save
      redirect_to admin_referencing_styles_path, notice: "Style was successfully saved"
    else
      render 'new'
    end
  end

  def show
    @style = ReferencingStyle.find(params[:id])
    authorize! :read, @style

    add_breadcrumb "Styles", admin_categories_path
    add_breadcrumb @style.name, admin_referencing_style_path(@style)
  end

  def edit
    @style = ReferencingStyle.find(params[:id])
    authorize! :update, @style

    add_breadcrumb "Styles", admin_categories_path
    add_breadcrumb @style.name, admin_referencing_style_path(@style)
    add_breadcrumb "Edit", edit_admin_referencing_style_path(@style)
  end

  def update
    @style = ReferencingStyle.find(params[:id])
    authorize! :update, @style

    if @style.update_attributes(referencing_style_params)
      redirect_to admin_referencing_styles_path, notice: "Style was successfully updated"
    else
      render 'edit'
    end
  end

  def destroy
    @style = ReferencingStyle.find(params[:id])
    authorize! :destroy, @style
  end

  private

  def referencing_style_params
    params.require(:referencing_style).permit(:name)
  end
end

