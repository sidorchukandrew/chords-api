class Team < ApplicationRecord
    has_and_belongs_to_many :users
    has_many :binders
    has_many :songs
    has_many :themes
end
