class ReportMailer < ActionMailer::Base
  default from: "donotreply@streetsensemedia.org"

  def daily_report(email, subject, fileNameArray)
    fileNameArray.each do |filename| 
      attachments[filename] = File.read(filename)
    end
    response = mail(to: email, subject: subject) do |format|
      format.text
    end
  end
end
