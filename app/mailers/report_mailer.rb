class ReportMailer < ActionMailer::Base
  default from: "report@streetsensemedia.org"

  def daily_report(email, subject, filename, file)
    # attachments[filename] = report
    response = mail(to: email, subject: subject)
    puts "sendgrid response: "
    puts response
  end
end
