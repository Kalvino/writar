class Admin < ActiveRecord::Base
  extend FriendlyId

  friendly_id :slug_candidates, use: :slugged
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  has_many :essays, :as => :owner
  has_many :transactions, :as => :owner
  has_many :approved_questions, class_name: "Question", foreign_key: :updated_by_id

  validates :timezone, inclusion: { in: ActiveSupport::TimeZone.zones_map(&:name).keys }

  enum role: [:guest, :clerk, :moderator, :admin]

  def name
    [first_name,last_name].join(" ")
  end

  private

  # Try building a slug based on the following fields in increasing order of specificity.
  def slug_candidates
    [
        [:first_name, :last_name]
    ]
  end
end
