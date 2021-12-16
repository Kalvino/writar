class NotificationMailer < ActionMailer::Base
  default from: ENV["SUPPORT_EMAIL"]

  def welcome_seller(seller)
    @seller = seller

    mail(to: @seller.email, subject: "Welcome to #{t('sitename')}")
  end

  def welcome_student(student)
    @student = student

    mail(to: @student.email, subject: "Thanks for joining!")
  end

  def send_paper(purchase)
    @purchase = purchase
    @essay = purchase.essay

    # attachment
    attachments[@essay.adjusted_document_name] = open(@essay.document.url).read
    mail(to: purchase.payer_email, subject: "#{t('sitename')}: Your paper is attached")
  end

  def send_email(email)
    @email = email

    mail(to: ENV["SUPPORT_EMAIL"], from: ENV["NOTIFICATIONS_EMAIL"], reply_to: email.address, subject: email.subject)
  end

  def withdrawal_confirmation(withdrawal)
    @withdrawal = withdrawal
  end

  def withdrawal_request(withdrawal)
    @withdrawal = withdrawal
    @seller = withdrawal.seller

    mail(to: ENV["SUPPORT_EMAIL"], from: ENV["NOTIFICATIONS_EMAIL"], subject: "New withdrawal request from #{@seller.name}")
  end

  def approved_paper(paper)
    @paper = paper
    @seller = @paper.owner

    mail(to: @seller.email, subject: "Your paper has been approved")
  end

  def purchased_paper(essay, transaction)
    @paper = essay
    @seller = @paper.owner
    @transaction = transaction
    @earnings = @paper.price - @paper.service_fee

    mail(to: @seller.email, subject: "Good news!! Someone purchased your paper")
  end

  def new_order(order)
    @order = order

    # attachments
    order.attachments.each do |attachment|
      attachments[attachment.file_file_name] = open(attachment.file.url).read
    end

    mail(to: ENV["SUPPORT_EMAIL"], from: ENV["NOTIFICATIONS_EMAIL"], subject: "New Order ##{@order.uid}")
  end

  def order_status(order)
    @order = order
    @user = @order.student
    mail(to: @user.email, from: ENV["NOTIFICATIONS_EMAIL"], subject: "Order ##{@order.uid}: Status Changed")
  end

  def leave_feedback(order)
    @order = order
    @user = @order.student
    mail(to: @user.email, subject: "Give us feedback for your recent order ##{@order.uid}")
  end

  def new_message(message)
    @message = message
    @user = message.user
    @order = message.order
    @url = @user.kind_of?(Admin) ? student_order_url(@order) : admin_order_url(@order)
    to_email = @user.kind_of?(Admin) ? @order.student.email : ENV["SUPPORT_EMAIL"]

    # attachments
    message.attachments.each do |attachment|
      attachments[attachment.file_file_name] = open(attachment.file.url).read
    end

    mail(to: to_email, from: ENV["NOTIFICATIONS_EMAIL"], subject: "Order ##{@order.uid}: New Message")
  end

  def payment_received(order)
    @order = order
    mail(to: ENV["SUPPORT_EMAIL"], from: ENV["NOTIFICATIONS_EMAIL"], subject: "Payment received for Order ##{@order.uid}")
  end

  def send_invoice(invoice)
    @invoice = invoice
    @order = invoice.order
    @student = @order.student
    mail(to: @student.email, subject: "Order ##{@order.uid}: New Quote")
  end

  def update_invoice(invoice)
    @invoice = invoice
    @order = invoice.order
    @student = @order.student
    mail(to: @student.email, subject: "Order ##{@order.uid}: Quote updated")
  end
end
