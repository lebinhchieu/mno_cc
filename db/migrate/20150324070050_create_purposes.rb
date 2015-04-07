class CreatePurposes < ActiveRecord::Migration
  def change
    create_table :purposes do |t|
      t.text :name
      t.text :code
      t.text :options
      t.integer :index

      t.timestamps null: false
    end
  end
end
