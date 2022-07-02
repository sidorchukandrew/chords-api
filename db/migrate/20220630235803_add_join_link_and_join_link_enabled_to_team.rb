class AddJoinLinkAndJoinLinkEnabledToTeam < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :join_link, :string, default: ''
    add_column :teams, :join_link_enabled, :boolean, default: false
  end
end
