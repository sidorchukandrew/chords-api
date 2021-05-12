class Binder < ApplicationRecord
    belongs_to :team
    has_and_belongs_to_many :songs
    
    validates :team_id, presence: true

    def remove_songs(song_ids)
        if song_ids && song_ids.length > 0
            self.songs.delete(Song.where(id: song_ids))
        end
    end

    def add_songs(song_ids)
        if song_ids && song_ids.length > 0
            self.songs.append(Song.where(id: song_ids))
        end
    end
end
