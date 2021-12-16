$crypt      = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
$redis      = Redis.new
$mailchimp  = Gibbon::Request.new
$s3         = Aws::S3::Resource.new region:'us-west-2'
$coder      = HTMLEntities.new
$intercom   = Intercom::Client.new(token: ENV["INTERCOM_ACCESS_TOKEN"])
