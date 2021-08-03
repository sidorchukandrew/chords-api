class CreateFormatConfigurations < ActiveRecord::Migration[6.1]
  def change
    create_table :format_configurations do |t|
      t.boolean :is_default
      t.belongs_to :team
      t.belongs_to :song
      t.belongs_to :user
      t.belongs_to :format
      t.timestamps
    end
  end
end
