class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :team
      t.belongs_to :user
      t.string :plan_name
      t.string :stripe_product_id
      t.string :stripe_price_id
      t.string :stripe_subscription_id
      t.boolean :calendar_enabled, default: false
      t.integer :max_songs, default: 100
      t.integer :max_setlists, default: 25
      t.integer :max_binders, default: 5
      t.timestamps
    end
  end
end
