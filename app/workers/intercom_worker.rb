class IntercomWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :intercom

  def perform(type, id)
    if type == "purchase"
      purchase = Purchase.find(id)
      # create intercom lead
      contact = $intercom.contacts.create(
          email: purchase.payer_email,
          name: purchase.payer_name,
          last_request_at: purchase.created_at.to_i
      )
      $intercom.tags.tag(name: 'buyers', users: [{ id: contact.id }])
    elsif type == "seller"
      seller = Seller.find(id)
      # create intercom user
      user = $intercom.users.create(
          user_id: "seller_#{seller.id}",
          email: seller.email,
          name: seller.name,
          signed_up_at: seller.created_at.to_i,
          last_seen_ip: seller.current_sign_in_ip.to_s
      )
      $intercom.tags.tag(name: 'sellers', users: [{id: user.id}])
    elsif type == "student"
      student = Student.find(id)
      # create intercom user
      user = $intercom.users.create(
          user_id: "student_#{student.id}",
          email: student.email,
          name: student.name,
          signed_up_at: student.created_at.to_i,
          last_seen_ip: student.current_sign_in_ip.to_s
      )
      $intercom.tags.tag(name: 'students', users: [{id: user.id}])
    end
  end
end
