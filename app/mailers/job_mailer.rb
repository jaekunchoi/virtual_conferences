class JobMailer < ActionMailer::Base
  default from: "jae.choi@commstrat.com.au"

  def csv_export_complete user
    begin
      @file_link = user.csv_file.assets.url
      attachments[@file_link] = File.open(@file_link)
      mail(to: user.email, subject: "CSV export has completed")
    rescue Exception => e
      logger.warn "Unable to send email: #{e}"
      mail(to: Rails.configuration.virtual_conferences.admin_email, subject: "CSV export failed", body: "Error details: #{e}")
    end
    
  end
end