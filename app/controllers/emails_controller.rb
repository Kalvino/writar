class EmailsController < ApplicationController

  def new
    @email = Email.new
    @active_section = :contact
  end

  def create
    @email = Email.new(email_params)
    if verify_recaptcha(model: @email) && @email.save
      NotificationMailer.delay.send_email(@email)
      redirect_to contact_path, notice: "We successfully received your message. We'll get back to you ASAP."
    else
      render 'new'
    end
  end

  private

  def email_params
    params.require(:email).permit(:first_name, :last_name, :address, :message, :subject)
  end
end
