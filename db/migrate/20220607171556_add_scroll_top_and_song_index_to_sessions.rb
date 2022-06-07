class AddScrollTopAndSongIndexToSessions < ActiveRecord::Migration[6.1]
  def change
    add_column :sessions, :scroll_top, :decimal, default: 0
    add_column :sessions, :song_index, :integer, default: 0
  end
end
