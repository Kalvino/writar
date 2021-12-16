# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = ENV["HOST"]

SitemapGenerator::Sitemap.create do
  add essays_path priority: 0.9, changefreq: 'daily'
  add about_path
  add contact_path
  add posts_path priority: 0.5, changefreq: 'weekly'
  add faqs_path priority: 0.2, changefreq: 'weekly'

  Essay.approved.find_each do |essay|
    add essay_path(essay), lastmod: essay.updated_at
  end

  Category.where.not(content: nil).each do |category|
    add category_index_path(category.name)
  end

  Post.uncategorized.published.find_each do |post|
    add post_path(post), lastmod: post.updated_at
  end

  Post.categorized.published.find_each do |post|
    add category_post_path(post.category.name, post), lastmod: post.updated_at
  end

  Question.find_each do |question|
    add question_path(question), lastmod: question.updated_at, priority: 1
  end

  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
