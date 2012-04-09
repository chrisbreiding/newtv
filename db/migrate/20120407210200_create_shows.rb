class CreateShows < ActiveRecord::Migration
	def up
		create_table :shows do |t|
			t.string :name
			t.string :tvrage_id
			
			t.timestamps
		end
	end

	def down
		drop_table :shows
	end
end