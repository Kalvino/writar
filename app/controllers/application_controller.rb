class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_raven_context

  around_filter :admin_time_zone, if: :current_admin
  around_filter :seller_time_zone, if: :current_seller
  around_filter :student_time_zone, if: :current_student

  skip_after_action :intercom_rails_auto_include

  helper_method :recent_essays, :categories, :posts, :more_posts

  def posts
    Post.uncategorized.published.recent
  end

  def more_posts
    Post.categorized.published.recent.limit(7)
  end

  def recent_essays
    Essay.approved.recent.limit(7)
  end

  def categories
    @categories ||= Category.all
  end

  def current_policy
    @current_policy ||= admin_signed_in? ? ::AccessPolicy.new(current_admin) : ::AccessPolicy.new(current_seller)
  end

  rescue_from AccessGranted::AccessDenied do |exception|
    if admin_signed_in?
      path = admin_dashboard_path
    elsif seller_signed_in?
      path = marketplace_dashboard_path
    elsif student_signed_in?
      path = student_dashboard_path
    end
    redirect_to path, alert: "You don't have permissions to access this page."
  end

  private

  def admin_time_zone(&block)
    Time.use_zone(current_admin.timezone, &block)
  end

  def seller_time_zone(&block)
    Time.use_zone(current_seller.timezone, &block)
  end

  def student_time_zone(&block)
    Time.use_zone(current_student.timezone, &block)
  end

  def set_raven_context
    if seller_signed_in?
      user = { name: current_seller.name, type: "seller", id: current_seller.id }
    elsif admin_signed_in?
      user = { name: current_admin.name, type: "admin", id: current_admin.id }
    elsif student_signed_in?
      user = { name: current_student.name, type: "student", id: current_student.id }
    else
      user = { name: "Visitor", id: "N/A" }
    end

    Raven.user_context(user) # or anything else in session
    Raven.extra_context(params: params.to_h, url: request.url)
  end

  def after_sign_up_path_for(resource)
    return after_auth_callbacks(resource) if resource.kind_of?(Student) && session[:order_id].present?
    root_path
  end

  def after_sign_in_path_for(resource)
    return admin_dashboard_path if resource.kind_of?(Admin)
    return marketplace_dashboard_path if resource.kind_of?(Seller)
    return after_auth_callbacks(resource) if session[:order_id]

    if student_signed_in?
      student_dashboard_path
    else
      request.env['omniauth.origin'] || stored_location_for(resource) || root_path
    end
  end

  def after_auth_callbacks(resource)
    order = Order.find(session[:order_id])
    order.update(student_id: resource.id)
    NotificationMailer.delay.new_order(order) # send email
    session.delete(:order_id)
    student_order_path(order)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up)        << [:name, :first_name, :last_name]
    devise_parameter_sanitizer.for(:account_update) << [:name, :first_name, :last_name, :timezone]
  end
end
