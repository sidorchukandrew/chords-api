class CreateJoinTableEventsMembers < ActiveRecord::Migration[6.1]
  def change
    create_join_table :events, :memberships
  end
end
