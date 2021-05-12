class AddDescriptionToBinders < ActiveRecord::Migration[6.1]
  def change
    add_column :binders, :description, :text
  end
end
