class AddPushNotificationTokenToDevices < ActiveRecord::Migration
  def up
    add_column :devices, :push_notification_token, :string
  end
  def down
    remove_column :devices, :push_notification_token, :string
  end
end
