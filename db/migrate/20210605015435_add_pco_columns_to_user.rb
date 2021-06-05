class AddPcoColumnsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :pco_access_token, :string
    add_column :teams, :pco_refresh_token, :string
    add_column :teams, :pco_token_created_at, :datetime
  end
end
