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

namespace :deploy do
  task :start do ; end
  task :stop do ; end

  # Needed for Passenger mod_rails:
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :symlink_config do
    shared_config = File.join(shared_path, 'config')
    release_config = "#{release_path}/config"
    %w{database}.each do |file|
      run "ln -s #{shared_config}/#{file}.yml #{release_config}/#{file}.yml"
    end
  end
end

after 'deploy:update_code' do
  deploy.symlink_config
end
