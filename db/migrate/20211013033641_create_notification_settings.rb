class CreateNotificationSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :notification_settings do |t|
      t.boolean :sms_enabled, default: false
      t.boolean :email_enabled, default: true
      t.boolean :app_enabled, default: false
      t.string :notification_type
      t.belongs_to :user
      
      t.timestamps
    end
  end
end
