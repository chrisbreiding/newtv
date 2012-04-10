class CreateEpisodes < ActiveRecord::Migration
	def change
		create_table :episodes do |t|
			t.integer :season
			t.integer :episode_number
			t.string :title
			t.integer :show_id
			t.date :airdate
			
			t.timestamps
		end
		add_index :episodes, :show_id
	end
end