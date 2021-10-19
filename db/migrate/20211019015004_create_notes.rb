class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.string :color
      t.integer :line_number
      t.text :content
      t.belongs_to :song
      t.timestamps
    end
  end
end
