class Purchase < ActiveRecord::Base
  belongs_to :vendor
  belongs_to :device
  belongs_to :paid_by, :class_name => "Administrator"

  has_many :purchase_products,  dependent: :destroy
  has_many :products, through: :purchase_products

  validates :vendor_id, presence: true
  validates :device_id, presence: true
  validates :products_amount, presence: true
  validates :transaction_id, presence: true

  def product_total
    if products.present?
      products.map { |product| product.price }.sum
    else
      return 0
    end
  end

  def total_amount
    # puts "tips #{tips}   products_amount #{products_amount}"
    tips + products_amount
  end

  # based on:
  # https://support.stripe.com/questions/can-i-charge-my-stripe-fees-to-my-customers
  def chargeable_amount 
    ((total_amount + 30) / (1 - 0.029)).round
  end

  # convert products_amount to dollar values.
  # make sure tips is next to it.
  def self.to_csv
    attributes = %w{id paid paid_at paid_by_id products_amount tips products_titles products_ids vendor_id device_id created_at updated_at payment_id transaction_id}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map do |attr| 
          if attr == 'products_amount' or attr == 'tips'
            #{'%.2f' % user.send(attr)}
          else
            user.send(attr)   
          end
        end
      end
    end
  end

  def products_titles
    products.map(&:title).uniq.join(", ")
  end

  def products_ids
    products.map(&:id).uniq.join(", ")
  end

end
