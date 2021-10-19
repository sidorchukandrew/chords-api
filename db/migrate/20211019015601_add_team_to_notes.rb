class AddTeamToNotes < ActiveRecord::Migration[6.1]
  def change
    add_reference :notes, :team, null: false, foreign_key: true
  end
end
