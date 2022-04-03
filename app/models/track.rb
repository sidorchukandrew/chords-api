class Track < ApplicationRecord
    belongs_to :song
    belongs_to :team
end
