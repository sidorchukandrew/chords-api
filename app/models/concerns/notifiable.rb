module Notifiable
  extend ActiveSupport::Concern

  def add_notification_settings
    NotificationSetting.find_or_create_by(user: self, notification_type: 'Event reminder')
  end

  def notify(notification)
    setup notification
    notify_by_email if @settings.email_enabled?
    notify_by_sms if @settings.sms_enabled?
    notify_by_app if @settings.app_enabled?
  end

  private

  def setup(notification)
    puts "Notification: #{notification}"
    @notification = notification
    notification_setting(notification[:type])
  end

  def notification_setting(type)
    puts "Looking for settings for #{type} in #{notification_settings.size}"
    @settings = notification_settings.find_by(notification_type: type)
  end

  def notify_by_email
    puts 'Notifying by email'
    NotificationsMailer.with(notification: @notification, user: self).event_reminder.deliver_later
  end

  def notify_by_sms
    client = Twilio::REST::Client.new
    puts "Sending text message to #{phone_number}"
    client.messages.create({
      from: ENV['TWILIO_NUMBER'],
      to: phone_number,
      body: @notification[:body]
    })
  end

  def notify_by_app
  end
end