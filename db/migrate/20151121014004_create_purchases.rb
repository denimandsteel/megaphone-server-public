class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.boolean  :paid, default: false
      t.datetime :paid_at
      t.integer  :paid_by_id
      t.integer  :amount
      t.integer  :vendor_id, index: true
      t.integer  :device_id, index: true

      t.timestamps null: false
    end
  end
end
