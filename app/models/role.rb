class Role < ApplicationRecord
    has_one :team
    has_many :memberships
    has_and_belongs_to_many :permissions
end
