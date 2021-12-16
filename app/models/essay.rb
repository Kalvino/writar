class Essay < ActiveRecord::Base
  extend FriendlyId
  include Filterable
  include Navigatable

  friendly_id :slug_candidates, use: [:slugged, :history]

  attr_accessor :current_user_type

  # include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks

  searchkick

  belongs_to :referencing_style
  belongs_to :category, :counter_cache => true
  belongs_to :owner, :polymorphic => true, :counter_cache => true
  has_many :thumbnails, dependent: :destroy
  has_many :purchases

  has_attached_file :document, hash_secret: ENV["PAPERCLIP_SECRET"], path: '/:env/:class/:attachment/:id/:hash.:extension'
  validates_attachment :document, presence: true,
                       content_type: { content_type: %w(application/msword 	application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.openxmlformats-officedocument.wordprocessingml.document application/vnd.openxmlformats-officedocument.presentationml.presentation application/vnd.ms-powerpoint application/pdf) }



  validates_presence_of :title, :price, :word_count, :page_count, :owner_id, :owner_type, :question,
                        :referencing_style_id, :category_id

  validates :question, length: { minimum: 20, too_short: "must have at least %{count} characters" }
  validates :title, length: { maximum: 250 }
  validates :preview, presence: true, if: :admin?
  validates :short_description, presence: true, length: { maximum: 255, too_long: "%{count} characters is the maximum allowed", minimum: 100, too_short: "must have at least %{count} characters" }, if: :admin?
  validates :document_fingerprint, :uniqueness => { :message => " matched. The document has already been uploaded." }

  before_create :add_paypal_margin

  enum status: [ :pending, :approved, :denied  ]

  scope :recent, -> { order("created_at DESC") }
  scope :search_import, -> { self.approved }

  # should index elastic search
  def should_index?
    status == "approved"
  end

  # Try building a slug based on the following fields in increasing order of specificity.
  def slug_candidates
    [
        :title,
        [:title, :category_id],
        [:title, :category_id, :referencing_style_id]
    ]
  end

  def should_generate_new_friendly_id?
    title_changed?
  end

  def search_data
    {
        title: title,
        question: question
    }
  end

  def adjusted_document_name
    ext = self.document_file_name.split(".").last
    new_name = self.title.titleize
    [new_name,".#{ext}"].join
  end

  def service_fee
    self.price * Transaction::SERVICE_FEE_PERCENTAGE
  end

  self.per_page = 25

  private

  def add_paypal_margin
    self.price = (price + (price*0.05)+0.3).round
  end

  def admin?
    self.current_user_type == "Admin"
  end
end
