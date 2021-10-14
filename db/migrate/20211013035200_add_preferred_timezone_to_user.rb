class AddPreferredTimezoneToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :timezone, :string, default: 'America/New York'
  end
end
