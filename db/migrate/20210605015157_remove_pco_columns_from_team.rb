class RemovePcoColumnsFromTeam < ActiveRecord::Migration[6.1]
  def change
    remove_column :teams, :pco_access_token
    remove_column :teams, :pco_refresh_token
    remove_column :teams, :pco_token_created_at
  end
end
