class CreateBinders < ActiveRecord::Migration[6.1]
  def change
    create_table :binders do |t|

      t.timestamps
    end
  end
end
