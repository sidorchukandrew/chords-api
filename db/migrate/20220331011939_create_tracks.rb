class CreateTracks < ActiveRecord::Migration[6.1]
  def change
    create_table :tracks do |t|
      t.references :song
      t.references :team
      t.string :url, default: ''
      t.string :artwork_url, default: ''
      t.string :external_id
      t.string :source
      t.timestamps
    end
  end
end
