class AddFontToSong < ActiveRecord::Migration[6.1]
  def change
    add_column :songs, :font, :string
  end
end
