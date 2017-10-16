task :send_daily_purchase_report => :environment do
  @setting_email = Setting.find_by(setting_name: "Daily Report Email Address")
  @setting_send_daily = Setting.find_by(setting_name: "Daily Report Send")

  todaysDate = Time.now.strftime("%Y-%d-%m")
  @filename = "#{todaysDate}-purchase-report.csv"

  if @setting_send_daily.setting_value == "true"
    puts "going to send email to"
    puts @setting_email.setting_value

    now = Time.now
    @purchases = Purchase.where(created_at: (now - 24.hours)..now)

    totalSales = @purchases.sum("products_amount") + @purchases.sum("tips")
    
    file = File.open(@filename, "w") do |csv|
      csv << @purchases.to_csv
    end

    @subject = "#{todaysDate}: Total Sales $#{totalSales}"
  
    puts "filename: #{@filename}"
    puts "subject: #{@subject}"

    puts ReportMailer.inspect
    
    mail = ReportMailer.daily_report(@setting_email.setting_value, @subject, @filename)

    mail = mail.deliver_now 
  end
end

