class Comment < ActiveRecord::Base
  belongs_to :post

  validates_presence_of :name, :email, :body, :post_id
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
end
