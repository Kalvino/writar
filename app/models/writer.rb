class Writer < ActiveRecord::Base
  extend FriendlyId

  friendly_id :slug_candidates, use: :slugged

  # default modules but disabled
  # :registerable, :recoverable, :rememberable, :trackable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :validatable

  has_many :orders, foreign_key: :assigned_to_id
  has_many :transactions, :as => :owner
  has_many :payouts, :as => :user

  validates_presence_of :first_name, :last_name, :phone, :rate_per_page
  validates :rate_per_page, numericality: { greater_than: 0 }

  def name
    [first_name,last_name].join(" ")
  end

  def earnings
    self.payouts.sum(:amount)
  end

  private

  # Try building a slug based on the following fields in increasing order of specificity.
  def slug_candidates
    [
        [:first_name, :last_name]
    ]
  end
end
