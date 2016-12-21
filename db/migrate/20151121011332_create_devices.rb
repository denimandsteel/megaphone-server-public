class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :payment_token
      t.string :api_token
      t.timestamps null: false
    end
  end
end
