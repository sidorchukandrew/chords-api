class ContactSubmissionsMailer < ApplicationMailer

  def contact_submitted
    @submission = params[:submission]
    puts '------------------------------------------'
    puts @submission
    puts '------------------------------------------'
    mail(to: ENV['EMAIL'], subject: 'Contact form submitted')
  end
end
