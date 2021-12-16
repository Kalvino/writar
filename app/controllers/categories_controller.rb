class CategoriesController < ApplicationController

  def index
    redirect_to essays_path
  end

  def show
    add_breadcrumb "Categories", :categories_path
    @category = Category.friendly.find(params[:id])
    @essays = @category.essays.recent.page(params[:page])
    add_breadcrumb @category.name, @category
    add_breadcrumb "Papers", "#"
  end
end
