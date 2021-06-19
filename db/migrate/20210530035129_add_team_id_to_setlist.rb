class AddTeamIdToSetlist < ActiveRecord::Migration[6.1]
  def change
    add_reference(:setlists, :team, index: true)
    add_foreign_key(:setlists, :teams)
  end
end
