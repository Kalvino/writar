class OrdersController < ApplicationController
  helper_method :resource_name, :resource, :devise_mapping

  def new
    @order = Order.new(hours_to_deadline: 336)
    @order = Order.find(session[:order_id]) if session[:order_id]

    add_breadcrumb "Orders", "#"
    add_breadcrumb "New", new_order_path
  end

  def create
    @order = Order.create(order_params)
    if @order.save
      if params[:files]
        params[:files].each do |file|
          attachment = @order.attachments.create(file: file)
          attachment.save
        end
      end
      if student_signed_in?
        @order.update(student_id: current_student.id)
        message =  @order.inquiry ? "You will receive a quote shortly" : "Proceed to make payment"
        redirect_to [:student, @order],notice: "Your order was successfully created. #{message}"
      else
        session[:order_id] = @order.id
        redirect_to personal_info_orders_path
      end
    else
      render :new
    end
  end

  def update
    @order = Order.find(session[:order_id])
    if @order.update(order_params)
      if params[:file]
        params[:files].each do |file|
          attachment = @order.attachments.create(file: file)
          attachment.save
        end
      end
      if student_signed_in?
        @order.update(student_id: current_student.id)
        redirect_to [:student, @order],notice: "Your order was successfully received. Proceed and make payment"
      else
        redirect_to personal_info_orders_path
      end
    else
      redirect_to new_order_path, alert: @order.errors.full_messages.join(",")
    end
  end

  def personal_info
    if session[:order_id]
      @order = Order.find(session[:order_id])
    else
      redirect_to new_order_path
    end

    add_breadcrumb "Orders", "#"
    add_breadcrumb "Personal Information", personal_info_orders_path
  end

  def inquiry
    @order = Order.new(inquiry: true)

    add_breadcrumb "Orders", "#"
    add_breadcrumb "Inquiry", inquiry_orders_path
  end

  private

  def resource_name
    :student
  end

  def resource
    @resource ||= Student.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:student]
  end

  def order_params
    params.require(:order).permit(:topic, :academic_level, :paper_type, :discipline, :time, :sources,:citation_style,
                                  :hours_to_deadline, :pages, :spacing, :instructions, :status, :inquiry, :uid)
  end
end
