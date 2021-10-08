class Team < ApplicationRecord
  include Subscribable

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :binders, dependent: :destroy
  has_many :songs, dependent: :destroy
  has_many :themes, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :setlists, dependent: :destroy
  has_many :roles, dependent: :destroy
  has_one_attached :image
  has_one :onsong_import
  has_one :subscription, dependent: :destroy

  before_destroy :cancel_subscription

  def make_admin(user)
    @membership = Membership.new do |membership|
      membership.user = user
      membership.role = Role.find_by(name: 'Admin', team_id: id)
    end

    memberships << @membership
  end

  def members
    memberships = self.memberships

    memberships.collect do |membership|
        user = membership.user
        {
          id: user.id,
          email: user.email,
          first_name: user.first_name,
          last_name: user.last_name,
          image_url: user.profile_picture&.variant(resize_to_limit: [200, 200])&.processed&.url,
          position: membership.position,
          joined_team_at: membership.created_at
        }
    end
  end

  def to_hash
    {
      name: self.name,
      id: self.id,
      created_at: self.created_at,
      updated_at: self.updated_at,
      image_url: self.image&.variant(resize_to_limit: [200, 200])&.processed&.url,
      memberships: self.memberships
    }
  end

  def with_image
    {
      name: self.name,
      id: self.id,
      created_at: self.created_at,
      updated_at: self.updated_at,
      image_url: self.image&.variant(resize_to_limit: [200, 200])&.processed&.url
    }
  end

  def add_default_roles
    roles << admin_role
    roles << member_role
  end

  private

  def admin_role
    Role.new do |role|
      role.name = 'Admin'
      role.description = 'Members in this role have full access and privileges.'
      role.is_admin = true
      role.permissions = Permission.all
    end
  end

  def member_role
    Role.new do |role|
      role.name = 'Member'
      role.description = 'Members in this role have read only access to songs, binders and sets. Members receive this role by default when they join a team.'
      role.is_member = true
      role.permissions = Permission.where(name: ['View songs', 'View sets', 'View binders'])
    end
  end
end
