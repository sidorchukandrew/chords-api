class CreateInvitations < ActiveRecord::Migration[6.1]
  def change
    create_table :invitations do |t|
      t.string :email
      t.references :team
      t.string :token
      t.timestamps
    end
  end
end
