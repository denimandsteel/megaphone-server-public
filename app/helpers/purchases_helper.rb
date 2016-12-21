module PurchasesHelper
  
  def products_titles_and_count(purchase)
    product_titles = purchase.products.pluck(:title)
    product_count = Hash.new(0)
    product_titles.each { |purchase| product_count[purchase] += 1 }

    return product_count
  end

  def purchases_date_range(unpaid_purchases)
    if @unpaid_purchases.first.created_at.day == @unpaid_purchases.last.created_at.day
      @unpaid_purchases.last.created_at.strftime("%b #{@unpaid_purchases.last.created_at.day}, %Y")
    else
      @unpaid_purchases.first.created_at.strftime("%b #{@unpaid_purchases.first.created_at.day}, %Y") + " to " + @unpaid_purchases.last.created_at.strftime("%B #{@unpaid_purchases.last.created_at.day}, %Y")
    end
  end
end
