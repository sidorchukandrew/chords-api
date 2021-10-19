class AddDefaultColorToNotes < ActiveRecord::Migration[6.1]
  def change
    change_column :notes, :color, :string, default: 'yellow'
  end
end
