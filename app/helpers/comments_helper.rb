module CommentsHelper
  def gravator_for(email, size=80,classes="media-object img-circle")
    hash = Digest::MD5.hexdigest(email)
    image_tag "https://www.gravatar.com/avatar/#{hash}?s=#{size}&d=identicon", class: classes
  end
end
