default_run_options[:pty] = true # http://help.github.com/capistrano/

set :application, "bdad"
set :repository,  "git://github.com/jroo/bdad.git"

set :scm, :git
set :user, "foo"

set :user, "bdad"
set :use_sudo, false
set :deploy_via, :remote_cache
set :deploy_to, "/projects/bdad/src/bdad"
set :domain, "ec2-184-73-118-224.compute-1.amazonaws.com"
# set :domain, "MetroCenter"
set :domain, "BdadMetroCenter"
set :branch, 'production'

role :web, domain
role :app, domain
role :db,  domain
# role :db, "morgan.sunlightlabs.org", :primary => true

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end