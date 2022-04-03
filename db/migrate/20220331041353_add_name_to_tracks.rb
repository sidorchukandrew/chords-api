class AddNameToTracks < ActiveRecord::Migration[6.1]
  def change
    add_column :tracks, :name, :string
  end
end
