class HomeController < ApplicationController
  def index
    @essays = Essay.approved.recent.limit(4)
    @category_count = Category.count
    @essay_count = Essay.approved.count
    @purchase_count = Purchase.count
    @posts = Post.published.recent.limit(2)
    @active_section = :home
  end

  def about
    @active_section = :about
  end
end
