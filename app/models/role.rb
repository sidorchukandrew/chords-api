
class Role < ApplicationRecord
  belongs_to :team
  has_many :memberships
  has_and_belongs_to_many :permissions

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
end
