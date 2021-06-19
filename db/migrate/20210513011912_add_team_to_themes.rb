class AddTeamToThemes < ActiveRecord::Migration[6.1]
  def change
    add_reference(:themes, :team, index: true)
    add_foreign_key(:themes, :teams)
  end
end
