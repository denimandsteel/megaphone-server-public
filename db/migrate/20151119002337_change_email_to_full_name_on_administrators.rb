class ChangeEmailToFullNameOnAdministrators < ActiveRecord::Migration
  def up
    rename_column :administrators, :email, :full_name
  end

  def down
    rename_column :administrators, :full_name, :email
  end  
end
