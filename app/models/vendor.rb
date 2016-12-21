class Vendor < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  has_and_belongs_to_many :products

  belongs_to :updated_by, :class_name => "Administrator"
  
  has_many :purchases
  has_many :locations
  has_many :payments
  accepts_nested_attributes_for :locations, reject_if: :all_blank, allow_destroy: true

  scope :has_unpaid_purchases, -> { includes(:purchases).where(purchases: { paid: false }) }

  validates :name, presence: true
  # validates :image, presence: true

  def unpaid_purchases
    purchases.where(paid: false)
  end

  def owed_amount
    unpaid_purchases.map { |purchase| purchase.total_amount }.sum if unpaid_purchases.any?
  end

end
