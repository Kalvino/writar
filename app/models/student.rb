class Student < ActiveRecord::Base
  include Filterable
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validate :timezone_exists, :name_exists
  before_save :set_country_and_timezone
  after_create :welcome_student, :add_intercom_user

  # relationships
  has_many :orders
  has_many :redemptions
  has_many :coupons, through: :redemptions

  # attr_writer
  def name=(val)
    self.first_name = val.split(" ")[0]
    self.last_name  = val.split(" ")[1]
  end

  # attr_reader
  def name
    return nil if first_name.nil? && last_name.nil?
    return [first_name, last_name].map(&:titleize).join(" ") if first_name.present? && last_name.present?
    return [first_name, last_name].join(" ") .titleize if first_name.present? || last_name.present?
  end

  # for intercom
  def custom_data
    { orders: orders_count }
  end

  private

  # Try building a slug based on the following fields in increasing order of specificity.
  def slug_candidates
    [
        [:first_name, :last_name],
        [:first_name, :last_name, :country]
    ]
  end

  def timezone_exists
    return if ActiveSupport::TimeZone[timezone].present?
    errors.add(:timezone, "'#{timezone}' does not exist")
  end

  def name_exists
    errors.add(:name, "can't be blank") unless first_name.present? || last_name.present?
  end

  def set_country_and_timezone
    if current_sign_in_ip_changed?
      details = IpTimezone.new(current_sign_in_ip.to_s).details
      self.country = details["countryCode"]
      self.timezone = details["timezone"]
    end
  end

  def welcome_student
    NotificationMailer.delay_until(1.hour.from_now).welcome_student(self)
  end

  def add_intercom_user
    IntercomWorker.perform_async("student", self.id)
  end
end
