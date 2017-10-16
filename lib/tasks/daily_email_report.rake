task :send_daily_purchase_report => :environment do
  @setting_email = Setting.find_by(setting_name: "Daily Report Email Address")
  @setting_send_daily = Setting.find_by(setting_name: "Daily Report Send")

  @subject = "Oct 13 2017: Total 48$"
  @filename = "oct-13-2017-purchase-report.csv"

  if @setting_send_daily.setting_value == "true"
    puts "send email to"
    puts @setting_email.setting_value

    @purchases = Purchase.all

    file = "test.csv"
    File.open(file, "w") do |csv|
      csv << @purchases.to_csv
    end
    
    ReportMailer.daily_report(@setting_email.setting_value, @subject, @filename, file)
  end
end

