class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :amount
      t.integer :paid_by_id
      t.references :vendor, index: true

      t.timestamps null: false
    end
  end
end
