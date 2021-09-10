class AddRoleToMembership < ActiveRecord::Migration[6.1]
  def change
    add_reference :memberships, :role
  end
end
