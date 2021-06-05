class CreateSetlists < ActiveRecord::Migration[6.1]
  def change
    create_table :setlists do |t|
      t.string :name
      t.date :scheduled_date
      t.timestamps
    end
  end
end
