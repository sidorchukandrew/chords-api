class AddFieldsToBinders < ActiveRecord::Migration[6.1]
  def change
    add_column(:binders, :name, :string)
    add_column(:binders, :color, :string)

    add_reference(:binders, :team, index: true)
    add_foreign_key(:binders, :teams)
  end
end
