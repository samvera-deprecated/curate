# List all tasks from RAILS_ROOT using: cap -T
#
# NOTE: The SCM command expects to be at the same path on both the local and
# remote machines. The default git path is: '/shared/git/bin/git'.

#############################################################
#  Settings
#############################################################

default_run_options[:pty] = true
set :use_sudo, false
ssh_options[:paranoid] = false

#############################################################
#  SCM
#############################################################

set :scm, :git
set :deploy_via, :remote_cache
set :scm_command, '/usr/bin/git'
set :branch, "master"

#############################################################
#  Environment
#############################################################

namespace :env do
  desc "Set command paths"
  task :set_paths do
    set :ruby,      File.join(ruby_bin, 'ruby')
    set :bundler,   File.join(ruby_bin, 'bundle')
    set :rake,      "#{bundler} exec #{File.join(shared_path, 'vendor/bundle/bin/rake')}"
  end
end

#############################################################
#  Passenger
#############################################################

desc "Restart Application"
task :restart_passenger do
  run "touch #{current_path}/tmp/restart.txt"
end

#############################################################
#  Database
#############################################################

namespace :db do
  desc "Run the seed rake task."
  task :seed, :roles => :app do
    run "cd #{current_path}; #{rake} RAILS_ENV=#{rails_env} db:seed"
  end
end

#############################################################
#  Deploy
#############################################################

namespace :deploy do
  desc "Execute various commands on the remote environment"
  task :debug, :roles => :app do
    run "/usr/bin/env", :pty => false, :shell => '/bin/bash'
    run "whoami"
    run "pwd"
    run "echo $PATH"
    run "which ruby"
    run "ruby --version"
    run "which rake"
    run "rake --version"
    run "which bundle"
    run "bundle --version"
  end

  desc "Start application in Passenger"
  task :start, :roles => :app do
    restart_passenger
  end

  desc "Restart application in Passenger"
  task :restart, :roles => :app do
    restart_passenger
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Run the migrate rake task."
  task :migrate, :roles => :app do
    run "cd #{release_path}; #{rake} RAILS_ENV=#{rails_env} db:migrate"
  end

  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    symlink_targets.each do | target |
      source, destination = target, target

      if target.respond_to?(:keys)
        source      = target.keys.first
        destination = target.values.first
      end

      run "ln -nfs #{File.join( shared_path, source)} #{File.join( release_path, destination)}"
    end
  end

  desc "Spool up Passenger spawner to keep user experience speedy"
  task :kickstart do
    run "curl -I http://#{domain}"
  end

  desc "Precompile assets"
  task :precompile do
    run "cd #{release_path}; #{rake} RAILS_ENV=#{rails_env} RAILS_GROUPS=assets assets:precompile"
  end
end

namespace :bundle do
  desc "Install gems in Gemfile"
  task :install, :roles => [:app, :work] do
    run "#{bundler} install --binstubs='#{release_path}/vendor/bundle/bin' --shebang '#{ruby}' --gemfile='#{release_path}/Gemfile' --without development test ci --deployment"
  end
end

namespace :worker do
  task :start, :roles => :work do
    target_file = "/opt/resque-pool-info"
    run [
      "echo \"RESQUE_POOL_ROOT=$(pwd)\" > #{target_file}",
      "echo \"RESQUE_POOL_ENV=#{fetch(:rails_env)}\" >> #{target_file}"
    ].join(" && ")
  end

  task :update_secrets, :roles => :work do
    run "scripts/update_secrets.sh"
  end
end

#############################################################
#  Callbacks
#############################################################

before 'deploy', 'env:set_paths'

#############################################################
#  Configuration
#############################################################

set :application, 'curate_nd'
set :repository,  "git@git.library.nd.edu:#{application}"

set :symlink_targets do
  [
    { '/bundle/config' => '/.bundle/config' },
    '/log',
    '/vendor/bundle',
    '/config/database.yml',
    '/config/solr.yml',
    '/config/redis.yml',
    '/config/fedora.yml',
    "/config/role_map_#{rails_env}.yml",
  ]
end

#############################################################
#  Environments
#############################################################

desc "Setup for the Pre-Production environment"
task :pre_production do
  set :rails_env,   'pre_production'
  set :deploy_to,   '/shared/ruby_pprd/data/app_home/curate'
  set :ruby_bin,    '/shared/ruby_pprd/ruby/1.9.3/bin'

  set :user,        'rbpprd'
  set :domain,      'curatepprd.library.nd.edu'

  default_environment['PATH'] = "#{ruby_bin}:$PATH"
  server "#{user}@#{domain}", :app, :web, :db, :primary => true

  after 'deploy:update_code', 'deploy:symlink_shared', 'bundle:install', 'deploy:migrate', 'deploy:precompile'
  after 'deploy', 'deploy:cleanup'
  after 'deploy', 'deploy:restart'
  after 'deploy', 'deploy:kickstart'
end

desc "Setup for the Staging Worker environment"
task :staging_worker do
  set :rails_env,   'pre_production'
  set :deploy_to,   '/home/curatend'
  set :ruby_bin,    '/usr/local/ruby/bin'

  set :user,        'curatend'
  set :domain,      'curatestagingw1.library.nd.edu'

  default_environment['PATH'] = "#{ruby_bin}:$PATH"
  server "#{user}@#{domain}", :work
  after 'deploy', 'worker:start'
  after 'deploy:update_code', 'bundle:install'
end
