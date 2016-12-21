class AddLastNotificationDateToProducts < ActiveRecord::Migration
  def up
    add_column :products, :last_notification_date, :datetime
  end
  def down
    remove_column :products, :last_notification_date, :datetime
  end
end
