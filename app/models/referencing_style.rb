class ReferencingStyle < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :essays
end
