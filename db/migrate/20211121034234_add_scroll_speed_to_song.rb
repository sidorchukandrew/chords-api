class AddScrollSpeedToSong < ActiveRecord::Migration[6.1]
  def change
    add_column :songs, :scroll_speed, :integer, default: 1
  end
end
