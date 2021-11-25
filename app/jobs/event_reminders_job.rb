class EventRemindersJob < ApplicationJob
  queue_as :default

  def perform(event_reminder_id)
    puts "Here's the id: #{event_reminder_id}"
    begin
      @event_reminder = EventReminder.find(event_reminder_id)
      @event = Event.includes(:memberships).find(@event_reminder.event_id)
      @members = @event.memberships.includes(:user)

      @members.each do |member|
        notification = build_notification(member.user.timezone)
        member.user.notify(notification)
      end
    rescue ActiveRecord::RecordNotFound => e
      puts 'Ignoring this reminder because there is no event attached to it'
      puts e
    end
  end

  def build_notification(timezone)
    {
      title: @event.title,
      description: @event.description,
      type: 'Event reminder',
      body: %(Cadence - Just a friendly reminder you have #{@event[:title]} coming up on #{@event.start_time.in_time_zone(timezone).strftime('%a %b %e, %I:%M %p')})
    }
  end
end
