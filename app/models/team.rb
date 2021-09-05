class Team < ApplicationRecord
    has_many :memberships, dependent: :delete_all
    has_many :users, through: :memberships
    has_many :binders, dependent: :delete_all
    has_many :songs, dependent: :delete_all
    has_many :themes, dependent: :delete_all
    has_many :invitations, dependent: :delete_all
    has_many :setlists, dependent: :delete_all

    has_one_attached :image

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
                image_url: user.profile_picture.url,
                is_admin: membership.is_admin,
                position: membership.position,
                joined_team_at: membership.created_at
            }
        end
    end

    def to_hash
        team_hash = {
            name: self.name,
            id: self.id,
            created_at: self.created_at,
            updated_at: self.updated_at,
            image_url: self.image&.url,
            memberships: self.memberships
        }
    end

    def with_image
        team_hash = {
            name: self.name,
            id: self.id,
            created_at: self.created_at,
            updated_at: self.updated_at,
            image_url: self.image&.url
        }
    end
end
