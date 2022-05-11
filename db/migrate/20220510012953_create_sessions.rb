class CreateSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions do |t|
      t.string :status
      t.belongs_to :team
      t.belongs_to :user
      t.belongs_to :setlist
      t.timestamps
    end
  end
end
