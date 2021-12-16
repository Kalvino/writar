class Admin::CategoriesController < ApplicationController
  layout "admin"

  before_action :authenticate_admin!

  add_breadcrumb "Admin", :admin_dashboard_path

  def index
    add_breadcrumb "Categories", admin_categories_path
    @categories = Category.all
    @active_section = :categories
    @current_action = :index
  end

  def new
    authorize! :create, Category

    @category = Category.new
    @active_section = :categories
    @current_action = :new

    add_breadcrumb "Categories", admin_categories_path
    add_breadcrumb "New", new_admin_category_path
  end

  def create
    authorize! :create, Category

    @category = Category.create(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: "Category was successfully saved"
    else
      render 'new'
    end
  end

  def show
    @category = Category.friendly.find(params[:id])
    authorize! :read, @category

    add_breadcrumb "Categories", admin_categories_path
    add_breadcrumb @category.name, admin_category_path(@category)
  end

  def edit
    @category = Category.friendly.find(params[:id])
    authorize! :update, @category

    add_breadcrumb "Categories", admin_categories_path
    add_breadcrumb @category.name, admin_category_path(@category)
    add_breadcrumb "Edit", edit_admin_category_path(@category)
  end

  def update
    @category = Category.friendly.find(params[:id])
    authorize! :update, @category

    if @category.update_attributes(category_params)
      redirect_to admin_categories_path, notice: "Category was successfully updated"
    else
      render 'edit'
    end
  end


  def destroy
    @category = Category.friendly.find(params[:id])
    authorize! :destroy, @category
  end

  private

  def category_params
    params.require(:category).permit(:name, :content, :title, :meta_description)
  end
end
