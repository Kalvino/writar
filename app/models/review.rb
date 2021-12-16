class Review < ActiveRecord::Base
  belongs_to :order

  validates_presence_of :content, :order_id
end
