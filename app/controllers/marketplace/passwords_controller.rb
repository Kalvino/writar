class Marketplace::PasswordsController < ApplicationController
  before_action :authenticate_seller!

  layout "marketplace"

  def edit
    @seller = current_seller
    @current_action = :password
    @active_section = :profile
  end

  def update
    @seller = current_seller

    if @seller.update_with_password(seller_params)
      # Sign in the user by passing validation in case his password changed
      flash[:notice] = "Your password was successfully updated"
      sign_in @seller, :bypass => true
      redirect_to [:marketplace, @seller]
    else
      @current_action = :password
      @active_section = :profile
      render 'edit'
    end
  end

  private

  def seller_params
    params.required(:seller).permit(:password, :password_confirmation, :current_password)
  end
end