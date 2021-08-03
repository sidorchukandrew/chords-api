class RemoveFormatColumnsFromSong < ActiveRecord::Migration[6.1]
  def change
    remove_column :songs, :font_size
    remove_column :songs, :font
    remove_column :songs, :bold_chords
    remove_column :songs, :italic_chords
  end
end
