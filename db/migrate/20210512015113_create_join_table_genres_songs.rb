class CreateJoinTableGenresSongs < ActiveRecord::Migration[6.1]
  def change
    create_join_table :genres, :songs do |t|
      t.index [:genre_id, :song_id]
      t.index [:song_id, :genre_id]
    end
  end
end
