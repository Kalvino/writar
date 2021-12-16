class Student::RedemptionsController < ApplicationController
  before_action :authenticate_student!

  def create
    @coupon = Coupon.find_by_code(params[:code])
    if @coupon.present?
      @order = Order.find(params[:order_id])
      status = @order.apply(@coupon)
      if status[:save]
        redirect_to :back, notice: status[:message]
      else
        redirect_to :back, alert: status[:message]
      end
    else
      redirect_to :back, alert: "Invalid coupon code: #{params[:code]}"
    end
  end
end
