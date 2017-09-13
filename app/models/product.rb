class Product < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  has_and_belongs_to_many :vendors

  after_update :only_one_in_app

  has_many :purchase_products
  has_many :purchases, through: :purchase_products

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :image, presence: true
  # validates :in_app, presence: true

  scope :available_in_app, -> { where(in_app: true) } 

  def price_in_dollars
    if price.nil?
      0.00
    else
      "%0.2f" % (price / 100.0)
    end
  end

  protected

  def only_one_in_app
    # only if newspaper, multiple feature products can appear in the app at the same time.
    if self.category == 'Newspaper'
      Product.where.not(id: self.id).where(category: self.category).update_all(in_app: false) if self.in_app? && Product.where.not(id: self.id).where(category: self.category).available_in_app.any?  
    end
  end
end
