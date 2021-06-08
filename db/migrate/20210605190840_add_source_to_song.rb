class AddSourceToSong < ActiveRecord::Migration[6.1]
  def change
    add_column :songs, :source, :string
  end
end
