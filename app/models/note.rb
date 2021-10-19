class Note < ApplicationRecord
  belongs_to :song
  belongs_to :team

  before_create :validate_song

  private

  def validate_song
    @song = Song.find(song_id)
    errors << 'Song does not belong to the current team' if @song.team_id != team_id
  end

end
