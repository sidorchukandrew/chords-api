class CreatePublicSetlists < ActiveRecord::Migration[6.1]
  def change
    create_table :public_setlists do |t|
      t.references :setlist
      t.string :code
      t.datetime :expires_on
      t.timestamps
    end
  end
end
