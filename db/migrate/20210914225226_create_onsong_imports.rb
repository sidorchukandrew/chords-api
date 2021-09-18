class CreateOnsongImports < ActiveRecord::Migration[6.1]
  def change
    create_table :onsong_imports do |t|
      t.belongs_to :team
      t.timestamps
    end
  end
end
