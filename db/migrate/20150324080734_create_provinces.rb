class CreateProvinces < ActiveRecord::Migration
  def change
    create_table :provinces do |t|
      t.text :name
      t.text :code

      t.timestamps null: false
    end
  end
end
