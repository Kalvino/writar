class Category < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged


  has_many :essays
  has_many :posts

  validates :name, presence: true, uniqueness: true, :case_sensitive => false

  def should_generate_new_friendly_id?
    name_changed? || slug.nil?
  end
end
