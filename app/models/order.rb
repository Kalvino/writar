class Order < ActiveRecord::Base
  extend FriendlyId
  include Filterable
  include Navigatable

  friendly_id :uid, use: :slugged

  belongs_to :student, counter_cache: true
  belongs_to :assigned_to, class_name: 'Writer', counter_cache: true
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :messages
  has_one :invoice
  has_one :review

  after_initialize :assign_uid, if: :new_record?
  before_save :convert_deadline_to_utc, :alert_status_changed, :prepare_invoice, :pay_writer

  enum status: [ :pending_quote, :pending_payment, :in_progress, :completed, :cancelled  ]

  def cost
    PriceCalculator.new(pages, hours_to_deadline, academic_level, spacing).cost
  end

  def files_in_messages
    message_ids = self.messages.map(&:id)
    Attachment.where(attachable_type: "Message", attachable_id: message_ids)
  end

  def progress
    case self.status
      when "pending_quote" then (1/4.0) * 100
      when "pending_payment" then (2/4.0) * 100
      when "in_progress" then (3/4.0) * 100
      else (4/4.0) * 100
    end
  end

  def amount
    return 0 unless invoice
    invoice.amount
  end

  def writer_amount
    assigned_to.rate_per_page * pages.to_i
  end

  def apply(coupon)
    student     = self.student
    valid_until = coupon.valid_until

    coupons = student.coupons.where(id: coupon.id)
    coupon_applied_for_order = Redemption.where(student_id: student.id, order_id: self.id)
    if coupons.any?
      { save: false, message: "The coupon code you provided has already been applied to your account" }
    elsif coupon_applied_for_order.any?
      { save: false, message: "You already applied a coupon code to this order" }
    else
      if !valid_until.nil? && valid_until < Time.zone.now
        { save: false, message: "Coupon already expired"}
      else
        coupon.redemptions.create!(order: self, student: self.student)
        { save: true, message: "Coupon code was successfully applied!" }
      end
    end
  end

  private

  def assign_uid
    loop do
      str = rand.to_s[2..11].rjust(10, '0')
      return self.uid = str unless Order.exists?(uid: str)
    end
  end

  def convert_deadline_to_utc
    date = created_at || Time.zone.now
    if student.nil?
      self.due_at = hours_to_deadline.to_i.hours.from_now(date).in_time_zone.utc
    else
      self.due_at = hours_to_deadline.to_i.hours.from_now(date).in_time_zone(student.timezone).utc
    end
  end

  def prepare_invoice
    unless inquiry
      if invoice.present?
        invoice.update(amount: cost, message: "Please pay this amount") if status == "pending_payment"
      else
        create_invoice(amount: cost, message: "Please pay this amount") if status == "pending_quote"
      end
    end
  end

  def alert_status_changed
    if status_changed?(from: "in_progress", to: "completed") || status_changed?(from: "in_progress", to: "cancelled")
      NotificationMailer.delay.order_status(self)
      NotificationMailer.delay_for(2.hours).leave_feedback(self)
    end
  end

  def pay_writer
    if status_changed?(from: "in_progress", to: "completed")
      assigned_to.transactions.create(amount: writer_amount, txn_type: "Order Payment", description: "Payment for order: ##{uid} at the rate of $#{assigned_to.rate_per_page}/page")
    end
  end
end
