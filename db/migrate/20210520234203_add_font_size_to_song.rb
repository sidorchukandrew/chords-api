class AddFontSizeToSong < ActiveRecord::Migration[6.1]
  def change
    add_column :songs, :font_size, :integer
  end
end
