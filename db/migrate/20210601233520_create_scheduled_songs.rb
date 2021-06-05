class CreateScheduledSongs < ActiveRecord::Migration[6.1]
  def change
    create_table :scheduled_songs do |t|
      t.belongs_to :setlist
      t.belongs_to :song
      t.integer :order
      t.timestamps
    end
  end
end
