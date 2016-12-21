class PurchaseProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :purchase
end
