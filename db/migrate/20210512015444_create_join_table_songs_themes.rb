class CreateJoinTableSongsThemes < ActiveRecord::Migration[6.1]
  def change
    create_join_table :songs, :themes do |t|
      t.index [:song_id, :theme_id]
      t.index [:theme_id, :song_id]
    end
  end
end
