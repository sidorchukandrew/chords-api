class AddRoadmapToSongs < ActiveRecord::Migration[6.1]
  def change
    add_column :songs, :roadmap, :string
  end
end
