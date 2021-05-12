class AddTeamToSongs < ActiveRecord::Migration[6.1]
  def change
    add_reference(:songs, :team)
    add_index(:songs, :team)
  end
end
