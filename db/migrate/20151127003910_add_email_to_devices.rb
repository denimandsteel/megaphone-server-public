class AddEmailToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :email, :string
  end
end
