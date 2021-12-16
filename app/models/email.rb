class Email < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :subject, :address, :message
  validates_format_of :address, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

  def sender_name
    [first_name, last_name].join(" ")
  end
end
