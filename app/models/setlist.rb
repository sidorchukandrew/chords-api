class Setlist < ApplicationRecord
    has_many :scheduled_songs, :dependent => :destroy
    has_many :songs, through: :scheduled_songs
    belongs_to :team
    has_many :public_setlists, :dependent => :destroy

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

    def add_songs(song_ids, current_user, current_member)
        last_position = self.scheduled_songs.count
        if song_ids && song_ids.length > 0
            song_ids.each do |song_id|
                self.scheduled_songs.append(ScheduledSong.new(song_id: song_id, position: last_position))
                last_position += 1
            end

            songs_with_positions(song_ids, current_user, current_member)
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

    def songs_with_positions(song_ids = nil, current_user, current_member)
        if song_ids
            @songs_with_positions = self.scheduled_songs.where(song_id: song_ids).order("position").collect do |schedule_data|
                song = schedule_data.song
                format = Format.for_song_and_user(song, current_user).first
                format = Format.for_song(song).first unless format.present?
                format = default_format if !format.present?
                notes = song.notes
                capo = song.capos.find_by(membership: current_member)&.as_json
                song_with_position = {
                    id: song.id,
                    name: song.name,
                    original_key: song.original_key,
                    transposed_key: song.transposed_key,
                    position: schedule_data.position,
                    content: song.content,
                    format: format.as_json,
                    notes: notes,
                    capo: capo,
                    roadmap: song.roadmap&.split('@')
                }
            end
        else
            @songs_with_positions = self.scheduled_songs.order("position").collect do |schedule_data|
                song = schedule_data.song
                format = Format.for_song_and_user(song, current_user).first
                format = Format.for_song(song).first unless format.present?
                format = default_format if !format.present?
                notes = song.notes
                capo = song.capos.find_by(membership: current_member)&.as_json
                song_with_position = {
                    id: song.id,
                    name: song.name,
                    original_key: song.original_key,
                    transposed_key: song.transposed_key,
                    position: schedule_data.position,
                    content: song.content,
                    format: format.as_json,
                    notes: notes,
                    capo: capo,
                    roadmap: song.roadmap&.split('@')
                }
            end
        end
    end

    private
     def default_format
      format = {
        font: 'Roboto Mono',
        font_size: 18,
        bold_chords: false,
        italic_chords: false
      }
    end
end
