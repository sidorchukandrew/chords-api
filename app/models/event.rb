class Event < ApplicationRecord
  belongs_to :team
  has_and_belongs_to_many :memberships
  has_one :event_reminder, dependent: :destroy

  validates :team_id, presence: true
  validates :title, presence: true
  validates :start_time, presence: true
  validate :members_in_team?

  after_create :schedule_reminder
  after_update :update_reminder

  private

  def members_in_team?
    return unless membership_ids

    team_member_ids = Membership.where(team_id: team_id).ids

    membership_ids.each do |id|
      errors.add(:membership_ids, "Id #{id} does not belong to a member in team #{team_id}") unless team_member_ids.include?(id)
    end
  end

  def schedule_reminder
    return unless reminders_enabled?

    reminder = EventReminder.new(event: self)
    reminder.save
    EventRemindersJob.set(wait_until: reminder_date).perform_later(reminder.id)
  end

  def update_reminder
    return unless saved_change_to_reminder_date? || saved_change_to_reminders_enabled?

    event_reminder.destroy if event_reminder.present?

    return unless reminders_enabled?

    updated_reminder = EventReminder.new(event: self)
    updated_reminder.save
    EventRemindersJob.set(wait_until: reminder_date).perform_later(updated_reminder.id)
  end

end
