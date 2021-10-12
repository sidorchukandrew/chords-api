class RenameNotificationsEnabledToRemindersEnabled < ActiveRecord::Migration[6.1]
  def change
    rename_column :events, :notifications_enabled, :reminders_enabled
  end
end
