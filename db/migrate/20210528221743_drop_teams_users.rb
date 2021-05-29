class DropTeamsUsers < ActiveRecord::Migration[6.1]
  def change
    drop_table :teams_users
  end
end
