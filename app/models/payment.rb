class Payment < ActiveRecord::Base
  belongs_to :vendor
  belongs_to :paid_by, :class_name => "Administrator"

  validates :vendor_id, presence: true
  validates :amount, presence: true
  validates :paid_by_id, presence: true
end
