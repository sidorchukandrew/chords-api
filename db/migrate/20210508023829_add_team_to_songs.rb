class AddTeamToSongs < ActiveRecord::Migration[6.1]
  def change
    add_reference(:songs, :team, index: true)
    add_foreign_key(:songs, :teams)
  end
end
