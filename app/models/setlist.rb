class Setlist < ApplicationRecord
    has_many :scheduled_songs
    has_many :songs, through: :scheduled_songs

    def remove_songs(song_ids)
        if song_ids && song_ids.length > 0
            song_ids.each do |song_id|
                scheduled_song = self.scheduled_songs.find_by_song_id(song_id)
                if scheduled_song
                    position = scheduled_song.position
                    self.scheduled_songs.where("position > ?", position).update_all("position = position - 1") 
                    scheduled_song.destroy
                end
            end
        end
    end

    def add_songs(song_ids)
        last_position = self.scheduled_songs.count
        if song_ids && song_ids.length > 0
            song_ids.each do |song_id|
                self.scheduled_songs.append(ScheduledSong.new(song_id: song_id, position: last_position))
                last_position += 1
            end

            songs_with_positions(song_ids)
        end
    end

    def update_song_order(song_id, new_position)
        @scheduled_song = self.scheduled_songs.find_by_song_id(song_id)
        past_position = @scheduled_song.position

        if new_position > past_position
            self.scheduled_songs.where("position > ?", past_position).where("position <= ?", new_position)
                .update_all("position = position - 1")
        elsif new_position < past_position
            self.scheduled_songs.where("position >= ?", new_position).where("position < ?", past_position)
                .update_all("position = position + 1")
        end

        @scheduled_song.position = new_position
        @scheduled_song.save
    end

    def songs_with_positions(song_ids = nil)

        if song_ids
            @songs_with_positions = self.scheduled_songs.where(song_id: song_ids).order("position").collect do |schedule_data|
                song = schedule_data.song
                song_with_position = {
                    id: song.id,
                    name: song.name,
                    key: song.key,
                    position: schedule_data.position
                }
            end
        else
            @songs_with_positions = self.scheduled_songs.order("position").collect do |schedule_data|
                song = schedule_data.song
                song_with_position = {
                    id: song.id,
                    name: song.name,
                    key: song.key,
                    position: schedule_data.position
                }
            end
        end
    end
end
