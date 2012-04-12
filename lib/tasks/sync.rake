namespace :cron do
	
	task :sync => :environment do
		require 'tvrage'
		
		c = ActiveRecord::Base.connection
		c.drop_table :episodes
		c.create_table :episodes do |t|
			t.integer :season
			t.string :episode_number
			t.string :title
			t.integer :show_id
			t.date :airdate
			
			t.timestamps
		end
		c.add_index :episodes, :show_id

		TvRage.sync
	end

end