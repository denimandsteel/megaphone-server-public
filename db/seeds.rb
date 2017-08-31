# Import vendors from csv files

# require 'csv'

# Vendor.delete_all

# csv_text = File.read('db/Street-Sense-Master-Vendor-Roster.csv')
# csv = CSV.parse(csv_text, :headers => true)
# csv.each do |row|
#   vendor = Vendor.find_or_create_by(badge_id: row['id'])
#   vendor.name = "#{row['first_name']} #{row['last_name']}"
#   vendor.in_app = false
#   vendor.has_back_issues = false
#   vendor.save!
# end

# csv_text = File.read('db/Street-Sense-Active-Vendors.csv')
# csv = CSV.parse(csv_text, :headers => true)
# csv.each do |row|
#   vendor = Vendor.find_or_create_by(badge_id: row['id'])
#   vendor.name = row['full_name']
#   vendor.in_app = true
#   vendor.has_back_issues = false
#   vendor.save! 
# end

Dir.entries("#{Rails.root}/db/Vendor-Headshots").each do |vendor_image|
  badge_id = vendor_image.split(' ')[0]
  puts "badge: #{badge_id}"
  vendor = Vendor.find_by(badge_id: badge_id)
  if vendor
    if vendor.name == "Amin Massey"
      puts "name: #{vendor.name}"
      vendor.image = File.open("#{Rails.root}/db/Vendor-Headshots/#{vendor_image}")
      vendor.save!
    end
  end
end