class ReportMailer < ActionMailer::Base
  default from: "donotreply@streetsensemedia.org"

  def daily_report(email, subject, filename)
    attachments[filename] = File.read(filename)
    response = mail(to: email, subject: subject) do |format|
      format.text
    end
  end
end
