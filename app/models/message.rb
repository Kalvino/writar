class Message < ActiveRecord::Base
  belongs_to :order
  belongs_to :user, polymorphic: true
  has_many :attachments, as: :attachable, dependent: :destroy

  validates_presence_of :user, :content, :order_id

  after_create :send_notification

  private

  def send_notification
    NotificationMailer.delay_until(30.seconds.from_now).new_message(self)
  end
end
