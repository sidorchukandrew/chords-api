class AddHighlightColorAndChordColorToFormat < ActiveRecord::Migration[6.1]
  def change
    add_column :formats, :highlight_color, :string, default: "rgba(255,255,255,0)"
    add_column :formats, :chord_color, :string, default: "rgba(0,0,0,1)"
    remove_column :formats, :chords_color
  end
end
