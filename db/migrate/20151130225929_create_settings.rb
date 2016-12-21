class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :setting_name
      t.string :setting_value

      t.timestamps null: false
    end
  end
end
