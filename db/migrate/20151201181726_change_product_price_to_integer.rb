class ChangeProductPriceToInteger < ActiveRecord::Migration
  def up
    change_column :products, :price, 'integer USING CAST(price AS integer)'
  end

  def down
    change_column :products, :price, :string
  end
end
