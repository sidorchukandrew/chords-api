class AddTeamToThemes < ActiveRecord::Migration[6.1]
  def change
    add_reference(:themes, :team)
    add_index(:themes, :team)
  end
end
