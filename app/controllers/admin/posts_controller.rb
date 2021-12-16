class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  layout "admin"

  add_breadcrumb "Admin", :admin_dashboard_path

  def index
    authorize! :read, Post

    add_breadcrumb "Posts", :admin_posts_path
    @active_section = :posts
    @current_action = :index
    @posts = Post.recent
  end

  def new
    authorize! :create, Post


    add_breadcrumb "Posts", :admin_posts_path
    add_breadcrumb "New", :new_admin_post_path

    @post = Post.new
    @active_section = :posts
    @current_action = :new
  end

  def create
    authorize! :create, Post

    @post = Post.create(post_params)
    if @post.save
      redirect_to [:admin, @post], notice: "Post successfully saved"
    else
      render 'new'
    end
  end

  def show
    add_breadcrumb "Posts", :admin_posts_path
    @post = Post.friendly.find(params[:id])
    authorize! :read, @post

    add_breadcrumb @post.title, [:admin, @post]
    @active_section = :posts
    @current_action = :show
  end

  def edit
    add_breadcrumb "Posts", :admin_posts_path
    @post = Post.friendly.find(params[:id])
    authorize! :update, @post

    add_breadcrumb @post.title, [:admin, @post]
    add_breadcrumb "Edit", edit_admin_post_path(@post)
  end

  def update
    @post = Post.friendly.find(params[:id])
    authorize! :update, @post

    if @post.update(post_params)
      redirect_to [:admin, @post], notice: "Post successfully updated"
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.friendly.find(params[:id])
    authorize! :destroy, @post

    @post.destroy
    redirect_to admin_posts_path, notice: "Post successfully deleted"
  end

  private

  def post_params
    params.require(:post).permit(:title, :body,:banner, :meta_description, :draft, :category_id)
  end
end
