class CreateTeamsUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :teams_users do |t|
      t.belongs_to :team
      t.belongs_to :user
      t.timestamps
    end
  end
end
