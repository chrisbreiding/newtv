namespace :tvsource do

  task :init => :environment do
    require 'tvsource'
    TvSource.set_initial_tvsource_time
  end

end
