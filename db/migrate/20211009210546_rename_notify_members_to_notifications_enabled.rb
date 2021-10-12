class RenameNotifyMembersToNotificationsEnabled < ActiveRecord::Migration[6.1]
  def change
    rename_column :events, :notify_members, :notifications_enabled
  end
end
