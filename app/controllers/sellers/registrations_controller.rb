class Sellers::RegistrationsController < Devise::RegistrationsController
  def edit
    @active_section = :profile
    @current_action = :profile
    super
  end

  def update
    successfully_updated = if needs_password?(current_seller, params)
                             @seller.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
                           else
                             # remove the virtual current_password attribute update_without_password
                             # doesn't know how to ignore it
                             params[:seller].delete(:current_password)
                             @seller.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
                           end

    if successfully_updated
      flash[:notice] = "Your personal details have been updated successfully"
      # Sign in the user bypassing validation in case his password changed
      sign_in current_seller, :bypass => true
      redirect_to after_update_path_for(current_seller)
    else
      render "edit"
    end
  end

  private

  # check if we need password to update user data
  def needs_password?(user, params)
    params[:seller][:password].present?
  end

  protected

  def after_update_path_for(resource)
    marketplace_seller_path(resource)
  end
end