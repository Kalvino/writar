class Seller < ActiveRecord::Base
  extend FriendlyId
  include Filterable

  friendly_id :slug_candidates, use: :slugged

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :username

  validates_format_of :paypal_email, :with => Devise.email_regexp, :if => Proc.new { |u| u.paypal_email.present? }
  validate :timezone_exists

  enum role: [:clerk, :moderator, :admin]

  scope :recent, -> { order("created_at DESC") }

  before_create :set_username
  before_save :set_timezone
  after_create :subscribe_seller, :add_intercom_user

  has_many :essays, :as => :owner
  has_many :purchases, through: :essays
  has_many :transactions, :as => :owner
  has_many :withdrawals

  def name
    [first_name, last_name].join(" ").titleize
  end

  def sales
    self.withdrawals.sum(:amount)
  end

  def after_confirmation
    NotificationMailer.delay.welcome_seller(self)
  end

  self.per_page = 25

  # for intercom
  def custom_data
    { papers: essays_count }
  end

  private

  def set_username
    self.username = [first_name,last_name, SecureRandom.hex(3)].join("-").strip.gsub(" ","").downcase
  end

  def subscribe_seller
    MailchimpWorker.perform_async(self.id)
  end

  def add_intercom_user
    IntercomWorker.perform_async("seller", self.id)
  end

  def set_timezone
    if current_sign_in_ip_changed?
      details = IpTimezone.new(current_sign_in_ip.to_s).details
      self.timezone = details["timezone"]
    end
  end

  def timezone_exists
    return if ActiveSupport::TimeZone[timezone].present?
    errors.add(:timezone, "'#{timezone}' does not exist")
  end

  # Try building a slug based on the following fields in increasing order of specificity.
  def slug_candidates
    [
        [:first_name, :last_name]
    ]
  end
end
