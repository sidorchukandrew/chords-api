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
end
