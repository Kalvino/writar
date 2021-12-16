class PostsController < ApplicationController
  add_breadcrumb "Blog", :posts_path

  def index
    @posts = Post.uncategorized.published.recent.page(params[:page])
    @active_section = :blog
  end

  def show
    @post = Post.friendly.find(params[:id])
    add_breadcrumb @post.title, @post
    @active_section = :blog
  end

  def category_index
    @category = Category.friendly.find(params[:category])
  end

  def category_show
    add_breadcrumb "Papers", :essays_path

    @category = Category.find_by name: params[:category]
    raise ActionController::RoutingError.new('Not Found') if @category.nil?
    @post = @category.posts.friendly.find params[:id]


    # @essays = @category.essays.approved.recent.page(params[:page])
    # @categories = Category.all
    #
    # add_breadcrumb "Category", "#"
    # add_breadcrumb "#{@category.name}", "#"
    # @active_section = :essays
  end
end
