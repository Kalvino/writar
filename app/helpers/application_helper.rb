module ApplicationHelper
  def heading(title)
    if title
      content_for :page_heading, title.titleize
    else
      content_for :page_heading, "Welcome"
    end
    title(title)
  end

  def title(page_title)
    if page_title
      if page_title.include? "|"
      content_for :title, page_title.to_s.titleize 
      else
        content_for :title, page_title.to_s.titleize + " | #{t("sitename")}"
      end
    else
      content_for :title, t("sitename")
    end
  end

  def errors_for(object)
    if object.errors.any?
      content_tag :div, class: "alert alert-dismissable alert-danger" do
        concat '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>'.html_safe
        concat content_tag(:h3, "Oh Snap!")
        object.errors.full_messages.each do |msg|
          concat content_tag(:p, msg)
        end
      end
    end
  end

  def flash_class(level)
    case level.to_sym
      when :notice then "alert alert-success"
      when :info then "alert alert-info"
      when :alert then "alert alert-danger"
      when :warning then "alert alert-warning"
    end
  end

  def encrypt(data)
    $crypt.encrypt_and_sign(data)
  end

  def open_graph_tags(title, url, type="website",description,image_url)
    %Q{
    <meta property="og:title" content="#{title}" />
    <meta property="og:type" content="#{type}"/>
    <meta property="og:url" content="#{url}"/>
    <meta property="og:image" content="#{image_url}"/>
    <meta property="fb:app_id" content="#{ENV["FACEBOOK_APP_ID"]}"/>
    <meta property="og:site_name" content="#{t("sitename")}"/>
    <meta property="og:description" content="#{$coder.decode(description)}"/>


    <meta name="twitter:card" content="summary" />
    <meta name="twitter:site" content="@papersmarket" />
    <meta name="twitter:title" content="#{title}" />
    <meta name="twitter:description" content="#{$coder.decode(description)}" />
    <meta name="twitter:image" content="#{image_url}" />
    }.html_safe
  end
end
