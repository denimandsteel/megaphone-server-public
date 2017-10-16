task :send_daily_purchase_report => :environment do
  @setting_email = Setting.find_by(setting_name: "Daily Report Email Address")
  @setting_send_daily = Setting.find_by(setting_name: "Daily Report Send")

  reportDate = (Date.today-1).strftime("%A %B %d, %Y")
  @filename = "#{reportDate} Purchase Report.csv"

  if @setting_send_daily.setting_value == "true"
    now = Time.now
    # This task is run at midnight so we want all purchases that happened yesterday:
    @purchases = Purchase.where("DATE(created_at) = ?", Date.today-1)
    totalSales = (@purchases.sum("products_amount") + @purchases.sum("tips")) / 100
    file = File.open(@filename, "w") do |csv|
      csv << @purchases.to_csv
    end
    @subject = "Street Sense Media - #{reportDate} Total Sales: $#{totalSales}"
    mail = ReportMailer.daily_report(@setting_email.setting_value, @subject, @filename)
    mail = mail.deliver_now 
  end
end

