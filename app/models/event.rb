class Event < ApplicationRecord
  belongs_to :team
  has_and_belongs_to_many :memberships

  validates :team_id, presence: true
  validates :title, presence: true
  validates :start_time, presence: true
  validate :members_in_team?

  private 
  
  def members_in_team?
    if membership_ids
      team_member_ids = Membership.where(team_id: team_id).ids

      membership_ids.each do |id|
        errors.add(:membership_ids, "Id #{id} does not belong to a member in team #{team_id}") unless team_member_ids.include?(id)
      end
    end

  end

end
