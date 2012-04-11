namespace :cron do
	
	task :sync => :environment do
		require 'tvrage'
		TvRage.sync
	end

end