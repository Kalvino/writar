module Admin::AdminsHelper
  def active_section(section)
    @active_section == section ? "active" : ""
  end

  def current_action(item)
    @current_action == item ? "active" : ""
  end

  def gravatar_for(email, size = 48, classes = "")
    hash = Digest::MD5.hexdigest(email)
    image_tag "https://www.gravatar.com/avatar/#{hash}?s=#{size}&d=identicon", class: classes
  end
end
