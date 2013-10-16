class CreateTvsource < ActiveRecord::Migration
  def change
    create_table :tvsource do |t|
      t.integer :last_updated

      t.timestamps
    end
  end
end
