class AddCoordinatesToNote < ActiveRecord::Migration[6.1]
  def change
    add_column :notes, :x, :integer, default: 0
    add_column :notes, :y, :integer, default: 0
  end
end
