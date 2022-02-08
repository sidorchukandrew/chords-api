
class Role < ApplicationRecord
  belongs_to :team
  has_many :memberships
  has_and_belongs_to_many :permissions

  before_destroy :move_everyone_to_members_role

  def add_permission(name)
    permission = Permission.find_by(name: name)

    permissions << permission
    self
  end

  def remove_permission(name)
    permission = Permission.find_by(name: name)

    permissions.delete(permission)
    self 
  end

  private

  def move_everyone_to_members_role
    @members_role = team.roles.find_by(is_member: true)
    memberships.each do |member|
      member.role = @members_role
      member.save
    end
  end
end
