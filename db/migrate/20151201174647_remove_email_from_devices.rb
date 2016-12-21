class RemoveEmailFromDevices < ActiveRecord::Migration
  def up
    remove_column :devices, :email, :string
  end

  def down
    add_column :devices, :email, :string
  end
end
