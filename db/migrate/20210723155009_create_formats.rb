class CreateFormats < ActiveRecord::Migration[6.1]
  def change
    create_table :formats do |t|
      t.string :font
      t.integer :font_size
      t.boolean :bold_chords
      t.boolean :italic_chords
      t.string :chords_color
      t.string :name
      t.timestamps
    end
  end
end
