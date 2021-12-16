class Post < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :comments, dependent: :destroy
  belongs_to :category
  validates_presence_of :title, :body, :meta_description, :banner

  has_attached_file :banner, styles: { medium: "768x432#"},
                    hash_secret: ENV["PAPERCLIP_SECRET"],
                    url: ':s3_alias_url',
                    s3_host_alias: 'd2w7ze5zknx9qe.cloudfront.net',
                    s3_protocol: :https,
                    path: '/:env/posts/:id/:style/:hash.:extension'
  validates_attachment_content_type :banner, content_type: /\Aimage\/.*\Z/

  scope :recent, -> { order("created_at DESC") }
  scope :published, -> { where(draft: false) }
  scope :uncategorized, -> { where(category_id: nil) }
  scope :categorized, -> { where.not(category_id: nil) }

  self.per_page = 10


  def download_remote_image(url)
    io = open(URI.parse(url))
    self.banner_file_name = io.base_uri.path.split('/').last
    self.banner = io
  end
end
