class AddCardTokenAndApplePayTokenToDevices < ActiveRecord::Migration
  def up
    add_column :devices, :card_token, :string
    add_column :devices, :apple_pay_token, :string
  end

  def down
    remove_column :devices, :card_token
    remove_column :devices, :apple_pay_token
  end
end
