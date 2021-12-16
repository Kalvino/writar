class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true

  has_attached_file :file, hash_secret: ENV["PAPERCLIP_SECRET"], path: '/:env/:class/:attachment/:id/:hash.:extension'
  # Explicitly do not validate
  do_not_validate_attachment_file_type :file
end
