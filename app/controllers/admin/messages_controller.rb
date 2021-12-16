class Admin::MessagesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_order

  layout "admin"

  def create
    @message = @order.messages.build(message_params)
    @message.user_type = current_admin.class.to_s
    if @message.save
      if params[:files]
        params[:files].each do |file|
          attachment = @message.attachments.create(file: file)
          attachment.save
        end
      end
      respond_to do |format|
        format.html { redirect_to [:admin, @order], notice: "Message successfully sent" }
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
    @order = Order.friendly.find(params[:order_id])
  end

  def message_params
    params.require(:message).permit(:content, :user_id)
  end
end
