class NotificationsMailer < ApplicationMailer

  # from should be changed to notifications@cadencechords.com? or reminders@cadencechords.com

  def event_reminder
    @recipient = params[:user]
    @notification = params[:notification]

    puts "Notifying #{@recipient.email} about #{@notification[:title]}"
    mail(to: @recipient.email, subject: 'Upcoming event')
  end

end
