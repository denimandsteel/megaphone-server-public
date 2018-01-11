class Device < ActiveRecord::Base
  has_many :purchases, -> { order 'created_at desc' }

  validates :api_token, presence: true
  # validates :payment_token, presence: true

  def recent_vendors
    if purchases.present?
      purchases.map { |purchase| purchase.vendor }.uniq{ |vendor| vendor.id }.select{ |vendor| vendor.in_app }
    else
      return nil
    end
  end
end
