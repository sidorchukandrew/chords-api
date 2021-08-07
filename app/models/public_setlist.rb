class PublicSetlist < ApplicationRecord
    belongs_to :setlist

    def to_hash
        setlist = self.setlist
        songs = setlist.scheduled_songs.order("position").collect do |scheduled_data|
            song = scheduled_data.song
            song = {
                content: song.content,
                name: song.name
            }
        end

        puts songs

        setlist = {
            songs: songs,
            name: setlist.name,
            code: self.code
        }

        setlist.as_json
    end
end
