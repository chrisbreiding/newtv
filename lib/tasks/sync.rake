namespace :cron do

  task :sync => :environment do
    require 'tvsource'
    TvSource.sync
  end

end
