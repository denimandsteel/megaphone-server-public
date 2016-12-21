class AddPaymentAndPermissionsToDevices < ActiveRecord::Migration
  def up
    add_column :devices, :enable_notifications, :boolean
    add_column :devices, :enable_location, :boolean
    add_column :devices, :last_four_digits, :string
  end
  def down
    remove_column :devices, :enable_notifications, :boolean
    remove_column :devices, :enable_location, :boolean
    remove_column :devices, :last_four_digits, :string
  end
end
