class Session < ApplicationRecord
    belongs_to :setlist
    belongs_to :user
    belongs_to :team
end
