# See http://help.github.com/capistrano/
default_run_options[:pty] = true 

set :application, "bdad"
set :repository,  "git://github.com/jroo/bdad.git"

set :scm, :git
set :user, "foo"

set :user, "bdad"
set :use_sudo, false
set :deploy_via, :remote_cache
set :deploy_to, "/projects/bdad/src/bdad"
set :domain, "dupont-bdad" # see .ssh/config
set :branch, 'production'

role :web, domain
role :app, domain
role :db,  domain

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
