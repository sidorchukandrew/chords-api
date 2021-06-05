class AddTeamIdToSetlist < ActiveRecord::Migration[6.1]
  def change
    add_reference(:setlists, :team)
    add_index(:setlists, :team)
  end
end
