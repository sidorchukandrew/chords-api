class Theme < ApplicationRecord
    has_and_belongs_to_many :songs
    belongs_to :team
end
