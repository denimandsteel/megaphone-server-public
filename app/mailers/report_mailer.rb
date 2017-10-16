class ReportMailer < ActionMailer::Base
  default from: "report@streetsensemedia.org"

  def daily_report(email, subject, filename)
    puts 'daily report called'
    puts "#{email}, #{subject}, #{filename}"
    attachments[filename] = File.read(filename)
    response = mail(to: email, subject: subject) do |format|
      format.text
    end
    puts "sendgrid response: "
    puts response
  end
end
