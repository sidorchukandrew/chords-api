class RemoveIsAdminFromMemberships < ActiveRecord::Migration[6.1]
  def change
    remove_column :memberships, :is_admin
  end
end
