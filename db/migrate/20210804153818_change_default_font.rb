class ChangeDefaultFont < ActiveRecord::Migration[6.1]
  def change
    change_column :formats, :font, :string, default: "Open Sans"
  end
end
