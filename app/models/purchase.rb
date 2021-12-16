class Purchase < ActiveRecord::Base
  extend FriendlyId
  include Filterable

  friendly_id :txn_id, use: :slugged

  belongs_to :essay
  has_many :transactions

  validates_presence_of :essay_id
  validates :payment_token, presence: true, uniqueness: true


  before_save :set_encoding

  def should_generate_new_friendly_id?
    txn_id_changed? || slug.nil?
  end

  def country
    ISO3166::Country.new(self.residence_country)
  end

  def payer_name
    [first_name,last_name].join(" ").titleize
  end

  private

  def set_encoding
    self.first_name = first_name.force_encoding('Windows-1252').encode('UTF-8') if first_name
    self.last_name  = last_name.force_encoding('Windows-1252').encode('UTF-8') if last_name
  end
end
