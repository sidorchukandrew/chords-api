class CreateSongs < ActiveRecord::Migration[6.1]
  def change
    create_table :songs do |t|
      t.string :name, null: false
      t.string :meter
      t.string :artist
      t.string :key
      t.integer :bpm
      t.text :content

      t.timestamps
      
      t.index :name
    end
  end
end
