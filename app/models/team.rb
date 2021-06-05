class Team < ApplicationRecord
    has_many :memberships, dependent: :delete_all
    has_many :users, through: :memberships
    has_many :binders, dependent: :delete_all
    has_many :songs, dependent: :delete_all
    has_many :themes, dependent: :delete_all
    has_many :invitations, dependent: :delete_all

    def make_admin(user)
        @membership = Membership.new do |membership|
            membership.user = user
            membership.is_admin = true
        end

        self.memberships << @membership
    end

    def members
        memberships = self.memberships

        members = memberships.collect do |membership|
            user = membership.user
            member = {
                id: user.id,
                email: user.email,
                first_name: user.first_name,
                last_name: user.last_name,
                image_url: user.image_url,
                is_admin: membership.is_admin,
                position: membership.position,
                joined_team_at: membership.created_at
            }
        end
    end
end
