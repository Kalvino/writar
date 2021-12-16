class Thumbnail < ActiveRecord::Base
  belongs_to :essay

  validates_presence_of :essay_id
  has_attached_file :file, styles: { medium: "500x647>", blurred: "500x647>", thumbnail: "" },
                    convert_options: { blurred: "-region 500x323+10+300 -blur 0x4", thumbnail: "-gravity north -thumbnail 500x320^ -extent 500x320" },
                    hash_secret: ENV["PAPERCLIP_SECRET"],
                    url: ':s3_alias_url',
                    s3_host_alias: 'd2w7ze5zknx9qe.cloudfront.net',
                    s3_protocol: :https,
                    path: '/:env/essays/documents/:essay_id/:class/:attachment/:id/:style/:hash.:extension'

  validates_attachment :file, presence: true, content_type: { content_type: /\Aimage\/.*\Z/ }

  default_scope { order("page_no ASC") }

  Paperclip.interpolates :essay_id do |attachment, style|
    attachment.instance.essay.id
  end
end
