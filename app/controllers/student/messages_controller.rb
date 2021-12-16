class Student::MessagesController < ApplicationController
  before_action :authenticate_student!
  before_action :set_order

  layout "admin"

  def new
  end

  def create
    @message = @order.messages.build(message_params)
    @message.user = current_student
    if @message.save
      if params[:files]
        params[:files].each do |file|
          attachment = @message.attachments.create(file: file)
          attachment.save
        end
      end
      respond_to do |format|
        format.html { redirect_to [:student, @order], notice: "Message successfully sent" }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js
      end
    end
  end

  private

  def set_order
    @order = current_student.orders.friendly.find(params[:order_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
