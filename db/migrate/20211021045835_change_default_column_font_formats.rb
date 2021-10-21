class ChangeDefaultColumnFontFormats < ActiveRecord::Migration[6.1]
  def change
    change_column :formats, :font, :string, default: 'Roboto Mono'
  end
end
