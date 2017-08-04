# Import vendors from csv files

require 'csv'

Vendor.delete_all

csv_text = File.read('db/Street-Sense-Master-Vendor-Roster.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  vendor = Vendor.find_or_create_by(id: row['id'])
  vendor.name = "#{row['first_name']} #{row['last_name']}"
  vendor.in_app = false
  vendor.has_back_issues = false
  vendor.save!
end

csv_text = File.read('db/Street-Sense-Active-Vendors.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  vendor = Vendor.find_or_create_by(id: row['id'])
  vendor.name = row['full_name']
  vendor.in_app = true
  vendor.has_back_issues = false
  vendor.save! 
end
