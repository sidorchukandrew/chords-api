class CreateJoinPermissionsRoles < ActiveRecord::Migration[6.1]
  def change
    create_join_table :permissions, :roles
  end
end
