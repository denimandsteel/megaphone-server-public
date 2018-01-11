task :send_daily_purchase_report => :environment do
  @setting_email = Setting.find_by(setting_name: "Daily Report Email Address")
  @setting_send_daily = Setting.find_by(setting_name: "Daily Report Send")

  reportDate = (Date.today-1).strftime("%A %B %d %Y")
  @filename_all = "#{reportDate}_All_Transactions.csv"
  @filename_unpaid = "#{reportDate}_Unpaid_Transactions.csv"

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
    @unpaid_purchases = Purchase.where("DATE(created_at) = ? AND paid = false", Date.today-1)
    totalUnpaidSales = (@unpaid_purchases.sum("products_amount") + @unpaid_purchases.sum("tips")) / 100
    file = File.open(@filename_unpaid, "w") do |csv|
      csv << @unpaid_purchases.to_csv
      csv << ['Total', '', '', totalUnpaidSales, ''].to_csv
    end

    @subject = "Total Sales: $#{totalSales} - #{reportDate} "
    mail = ReportMailer.daily_report(@setting_email.setting_value, @subject, [@filename_all, @filename_unpaid])
    mail = mail.deliver_now 
  end
end

