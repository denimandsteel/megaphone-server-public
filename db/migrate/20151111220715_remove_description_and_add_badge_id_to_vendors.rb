class RemoveDescriptionAndAddBadgeIdToVendors < ActiveRecord::Migration
  def up
    remove_column :vendors, :description, :string
    add_column :vendors, :badge_id, :integer
  end
  def down
    add_column :vendors, :description, :string
    remove_column :vendors, :badge_id, :integer
  end
end
