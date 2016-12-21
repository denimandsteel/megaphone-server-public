class RemoveAvailableOnFromProducts < ActiveRecord::Migration
  def up
    remove_column :products, :available_on, :datetime
  end
  def down
    add_column :products, :available_on, :datetime
  end
end
