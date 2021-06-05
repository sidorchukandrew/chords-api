class CreateJoinTableSetlistSongs < ActiveRecord::Migration[6.1]
  def change
    create_join_table :setlists, :songs do |t|
      t.index [:setlist_id, :song_id]
      t.index [:song_id, :setlist_id]
    end
  end
end
