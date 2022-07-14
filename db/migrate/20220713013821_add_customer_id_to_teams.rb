class AddCustomerIdToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :customer_id, :string
  end
end
