set :application, "newtv"
set :repository,  "git@github.com:chrisbreiding/newtv.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_to, "/srv/www/newtv.crbapps.com"

role :web, "chrisbreiding.com"                          # Your HTTP server, Apache/etc
role :app, "chrisbreiding.com"                          # This may be the same as your `Web` server
role :db,  "chrisbreiding.com", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

set :user, "root"
set :scm_username, "chrisbreiding"
set :use_sudo, false

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

# whenever cron jobs
require "whenever/capistrano"