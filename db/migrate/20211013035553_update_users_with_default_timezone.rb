class UpdateUsersWithDefaultTimezone < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :timezone, :string, default: 'America/New_York'
  end
end
