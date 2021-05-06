class AddIsAdminToTeamsUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :teams_users, :is_admin, :boolean
  end
end
