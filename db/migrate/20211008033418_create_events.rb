class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.belongs_to :team, null: false, foreign_key: true
      t.text :description
      t.string :title
      t.string :color
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :notify_members
      t.datetime :reminder_date

      t.timestamps
    end
  end
end
