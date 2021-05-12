class JoinBindersSongs < ActiveRecord::Migration[6.1]
  def change
    create_table :binders_songs do |t|
      t.belongs_to :binder
      t.belongs_to :song
      t.timestamps
    end
  end
end
