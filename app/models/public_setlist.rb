class PublicSetlist < ApplicationRecord
    belongs_to :setlist

    scope :active, -> { where("expires_on > ?", Time.current.utc) }

    def to_hash
        setlist = self.setlist
        songs = setlist.scheduled_songs.order("position").collect do |scheduled_data|
            song = scheduled_data.song
            song = {
                content: song.content,
                name: song.name
            }
        end

        setlist = {
            songs: songs,
            name: setlist.name,
            code: self.code,
            link: "#{ENV['PUBLIC_WEB_APP_BASE_URL']}/setlists/#{self.code}",
            expires_on: self.expires_on
        }

        setlist.as_json
    end
end
