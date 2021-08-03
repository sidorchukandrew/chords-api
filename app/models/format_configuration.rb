class FormatConfiguration < ApplicationRecord
    belongs_to :format
    belongs_to :song
    belongs_to :user
    belongs_to :team
end
