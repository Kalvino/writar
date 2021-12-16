Paperclip::Attachment.default_options[:url] = ':s3_domain_url'

Paperclip.interpolates :env do |attachment, style|
  Rails.env
end