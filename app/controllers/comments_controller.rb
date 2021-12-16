class CommentsController < ApplicationController
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    if verify_recaptcha(model: @comment) && @comment.save
      redirect_to @post, notice: "Comment successfully posted"
    else
      redirect_to @post, alert: @comment.errors.full_messages.join(",")
    end
  end

  private

  def set_post
    @post = Post.friendly.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:name, :email, :body)
  end
end
