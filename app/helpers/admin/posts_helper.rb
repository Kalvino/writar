module Admin::PostsHelper
  def admin_gravator_for(email)
    hash = Digest::MD5.hexdigest(email)
    image_tag "https://www.gravatar.com/avatar/#{hash}?s=40&d=identicon", class: ""
  end
end
