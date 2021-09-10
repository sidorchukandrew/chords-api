class CreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.string :description
      t.belongs_to :team
      t.timestamps
    end
  end
end
