class AddTransposedColumnsToSong < ActiveRecord::Migration[6.1]
  def change
    add_column :songs, :transposed_key, :string
    rename_column :songs, :key, :original_key
  end
end
