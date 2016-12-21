class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string     :price
      t.text       :description
      t.string     :title
      t.boolean    :on_sale
      t.string     :image
      t.datetime   :available_on

      t.timestamps null: false
    end
  end
end
