class EventRemindersJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    puts "Here's the id: #{event_id}"
    begin
      @event = Event.includes(:memberships).find(event_id)
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
      body: %(Just a friendly reminder you have #{@event[:title]} coming up on
              #{@event.start_time.in_time_zone(timezone).strftime('%a %b %e, %I:%M %p')})
    }
  end
end
