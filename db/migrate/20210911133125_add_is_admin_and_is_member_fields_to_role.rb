class AddIsAdminAndIsMemberFieldsToRole < ActiveRecord::Migration[6.1]
  def change
    add_column :roles, :is_admin, :boolean, default: false
    add_column :roles, :is_member, :boolean, default: false
  end
end
