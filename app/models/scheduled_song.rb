class ScheduledSong < ApplicationRecord
    belongs_to :setlist
    belongs_to :song
end
