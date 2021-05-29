class CreateMemberships < ActiveRecord::Migration[6.1]
  def change
    create_table :memberships do |t|
      t.belongs_to :user
      t.belongs_to :team
      t.boolean :is_admin
      t.string :position
      t.timestamps
    end
  end
end
