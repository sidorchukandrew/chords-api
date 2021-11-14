class CreateCapos < ActiveRecord::Migration[6.1]
  def change
    create_table :capos do |t|
      t.references :song
      t.references :membership
      t.string :capo_key
      t.timestamps
    end
  end
end
