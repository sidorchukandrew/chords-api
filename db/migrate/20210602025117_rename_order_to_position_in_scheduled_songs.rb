class RenameOrderToPositionInScheduledSongs < ActiveRecord::Migration[6.1]
  def change
    rename_column :scheduled_songs, :order, :position
  end
end
