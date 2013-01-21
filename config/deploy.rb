require 'lib/deploy/passenger'
# List all tasks from RAILS_ROOT using: cap -T

# NOTE: The SCM command expects to be at the same path on both the local and
# remote machines. The default git path is: '/shared/git/bin/git'.

#############################################################
#  Configuration
#############################################################

set :application, 'curate_nd'
set :repository,  "git@git.library.nd.edu:#{application}"

set :symlink_targets, [
  { '/bundle/config' => '/.bundle/config' },
  '/log',
  '/vendor/bundle'
]

#############################################################
#  Environments
#############################################################

desc "Setup for the Pre-Production environment"
task :pre_production do
  set :rails_env, 'pre_production'
  set :deploy_to, '/shared/ruby_pprd/data/app_home/curate'
  set :ruby_bin,  '/shared/ruby_pprd/ruby/bin'

  set :user,      'rbpprd'
  set :domain,    'reformatting.rpprd.library.nd.edu'

  default_environment['PATH'] = "#{ruby_bin}:$PATH"
  server "#{user}@#{domain}", :app, :web, :db, :primary => true
end
