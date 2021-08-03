class MoveIsDefaultFromConfigurationToFormat < ActiveRecord::Migration[6.1]
  def change
    remove_column :format_configurations, :is_default
    add_column :formats, :is_default, :boolean
  end
end
