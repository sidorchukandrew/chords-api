class AddBoldItalicColumnsToSong < ActiveRecord::Migration[6.1]
  def change
    add_column :songs, :bold_chords, :boolean
    add_column :songs, :italic_chords, :boolean
  end
end
