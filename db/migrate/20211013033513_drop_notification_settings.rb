class DropNotificationSettings < ActiveRecord::Migration[6.1]
  def change
    drop_table :notification_settings
  end
end
