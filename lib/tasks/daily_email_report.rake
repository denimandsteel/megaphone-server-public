# > rake send_daily_purchase_report
task :send_daily_purchase_report => :environment do
  @setting_email = Setting.find_by(setting_name: "Daily Report Email Address")
  @setting_send_daily = Setting.find_by(setting_name: "Daily Report Send")

  reportDate = (Date.today-1).strftime("%b-%d-%Y")
  @filename_all = "Daily_#{reportDate}.csv"
  @filename_unpaid = "Unpaid_#{reportDate}.csv"

  if @setting_send_daily.setting_value == "true"
    now = Time.now
    # This task is run at midnight so we want all purchases that happened yesterday:
    
    # First report: All Transactions
    @purchases = Purchase.where("DATE(created_at) = ?", Date.today-1)
    totalSales = (@purchases.sum("products_amount") + @purchases.sum("tips")) / 100
    file = File.open(@filename_all, "w") do |csv|
      csv << @purchases.to_csv
      csv << ['Total', '', '', totalSales, ''].to_csv
    end

    # Second report: Unpaid Transactions
    @unpaid_purchases = Purchase.where("paid = false")
    totalUnpaidSales = (@unpaid_purchases.sum("products_amount") + @unpaid_purchases.sum("tips")) / 100
    file = File.open(@filename_unpaid, "w") do |csv|
      csv << @unpaid_purchases.to_csv
      csv << ['Total', '', '', totalUnpaidSales, ''].to_csv
    end

    @subject = "#{reportDate} - Purchase Report"

    body = "Daily Sales: $#{totalSales}\n";
    body += "Unpaid so far: $#{totalUnpaidSales}\n";

    mail = ReportMailer.daily_report(@setting_email.setting_value, @subject, body, [@filename_all, @filename_unpaid])
    mail = mail.deliver_now 
  end
end

