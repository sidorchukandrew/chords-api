class AddPcoColumnsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :pco_access_token, :string
    add_column :users, :pco_refresh_token, :string
    add_column :users, :pco_token_expires_at, :datetime
  end
end
