class Student::ReviewsController < ApplicationController
  before_action :authenticate_student!
  before_action :set_order

  layout "admin"

  def new
    @review = Review.new

    add_breadcrumb "Orders", :student_orders_path
    add_breadcrumb "##{@order.uid}", student_order_path(@order)
    add_breadcrumb "Review", new_student_order_reviews_path(@order)
  end

  def create
    @review = @order.create_review(review_params)
    if @review.save
      redirect_to [:student, @order], notice: "Thank you for your feedback. Appreciated"
    else
      render :new
    end
  end

  private

  def set_order
    @order = current_student.orders.friendly.find(params[:order_id])
  end

  def review_params
    params.require(:review).permit(:content)
  end
end
