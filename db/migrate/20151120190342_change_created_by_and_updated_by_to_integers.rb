class ChangeCreatedByAndUpdatedByToIntegers < ActiveRecord::Migration
  def up
    Administrator.update_all(created_by: nil)
    Vendor.update_all(updated_by: nil)

    rename_column :administrators, :created_by, :created_by_id
    rename_column :vendors, :updated_by, :updated_by_id

    change_column :administrators, :created_by_id, 'integer USING CAST(created_by_id AS integer)'
    change_column :vendors, :updated_by_id, 'integer USING CAST(updated_by_id AS integer)'
  end

  def down
    change_column :administrators, :created_by_id, :string
    change_column :vendors, :updated_by_id, :string

    rename_column :administrators, :created_by_id, :created_by
    rename_column :vendors, :updated_by_id, :updated_by
  end  
end
