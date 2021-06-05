class DropSetlistSongs < ActiveRecord::Migration[6.1]
  def change
    drop_table :setlists_songs
  end
end
