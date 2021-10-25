class ContactSubmissionsMailer < ApplicationMailer

  def contact_submitted
    @submission = params[:submission]
    mail(to: ENV['EMAIL'], subject: 'Contact form submitted')
  end
end
