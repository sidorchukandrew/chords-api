class AddDefaultFormattingToNewFormat < ActiveRecord::Migration[6.1]
  def change
    change_column :formats, :font, :string, default: "Courier New"
    change_column :formats, :font_size, :integer, default: 18
    change_column :formats, :bold_chords, :boolean, default: false
    change_column :formats, :italic_chords, :boolean, default: false
  end
end
