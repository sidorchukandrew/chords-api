class AddIsActiveToPublicSetlists < ActiveRecord::Migration[6.1]
  def change
    add_column :public_setlists, :is_active, :boolean, default: false
  end
end
