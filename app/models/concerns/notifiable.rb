require 'rest-client'

module Notifiable
  extend ActiveSupport::Concern

  def add_notification_settings
    NotificationSetting.find_or_create_by(user: self, notification_type: 'Event reminder')
  end

  def notify(notification)
    setup notification
    notify_by_email if @settings.email_enabled?
    notify_by_sms if @settings.sms_enabled?
    notify_by_push if @settings.push_enabled?
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

  def notify_by_push
    puts "Notifying by push"

    push_notification = {
      app_id: ENV['ONE_SIGNAL_APP_ID'],
      include_external_user_ids: [self.uid],
      contents: {"en": @notification[:body]},
      subtitle: {"en": @notification[:title]} 
    }

    headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Basic #{ENV['ONE_SIGNAL_REST_API_KEY']}"
    }

    begin
      RestClient.post("#{ENV['ONE_SIGNAL_API_BASE_URL']}/notifications", push_notification, headers)
    rescue StandardError => e
      puts "Error when calling OneSignal->create_notification: #{e}"
    end
  end
end