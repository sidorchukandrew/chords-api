class RenameAppEnabledToPushEnabled < ActiveRecord::Migration[6.1]
  def change
    rename_column :notification_settings, :app_enabled, :push_enabled
  end
end
