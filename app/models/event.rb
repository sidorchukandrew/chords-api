class Event < ApplicationRecord
  belongs_to :team
  has_and_belongs_to_many :memberships

  validates :team_id, presence: true
  validates :title, presence: true
  validates :start_time, presence: true
  validate :members_in_team?

  after_create :schedule_reminder

  private

  def members_in_team?
    if membership_ids
      team_member_ids = Membership.where(team_id: team_id).ids

      membership_ids.each do |id|
        errors.add(:membership_ids, "Id #{id} does not belong to a member in team #{team_id}") unless team_member_ids.include?(id)
      end
    end
  end

  def schedule_reminder
    EventRemindersJob.set(wait_until: reminder_date).perform_later(id) if reminders_enabled
  end
end
