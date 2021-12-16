class Question < ActiveRecord::Base
  extend FriendlyId
  include Navigatable
  include Filterable

  belongs_to :updated_by, class_name: "Admin"
  attr_accessor :admin_id

  scope :current_month, -> { where("updated_at >= ?", Time.zone.now.beginning_of_month) }

  friendly_id :title, use: [:slugged, :history]

  validates_presence_of :title, :content
  validates_uniqueness_of :retrieved_from, allow_nil: true
  validates :retrieved_from, url: true

  validates :title, length: { maximum: 250 }

  scope :recent, -> { order("created_at DESC") }

  before_save :set_updated_by, :cleanup_content

  enum status: [ :pending, :approved, :denied  ]

  def should_generate_new_friendly_id?
    title_changed? || slug.nil?
  end

  private

  def set_updated_by
    if status_changed?(from: "pending", to: "approved")
      self.updated_by_id = admin_id
    end
  end

  def cleanup_content
    self.content = content.gsub(/<a .*click here.*<\/a>/i,'').gsub(/<a .*proessaywriting\.net.*<\/a>/,'')
    # gsub(/<div style=.*">(.*)<\/div>/,"<p>#{$1}</p>")
  end
end
