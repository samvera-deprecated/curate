# -*- encoding : utf-8 -*-
require 'rails/generators'
require 'rails/generators/migration'     


class CurateGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)
  
  
  desc """
This generator makes the following changes to your application:
 1. Adds the curate routes
 2. Adds a user migration
       """ 
  # Implement the required interface for Rails::Generators::Migration.
  # taken from http://github.com/rails/rails/blob/master/activerecord/lib/generators/active_record.rb
  def self.next_migration_number(path)
    unless @prev_migration_nr
      @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
    else
      @prev_migration_nr += 1
    end
    @prev_migration_nr.to_s
  end

  # Setup the database migrations
  def copy_migrations
    sleep 6 # Mailboxer just uses a sequence, so it can end up using our sequence numbers.
    # Can't get this any more DRY, because we need this order.
    %w{add_terms_of_service_to_user.rb add_user_force_update_profile.rb}.each do |f|
      better_migration_template f
    end
  end

  # The engine routes have to come after the devise routes so that /users/sign_in will work
  def inject_routes
    routing_code = "\n  curate_for :containers=>[:senior_theses]\n"
    sentinel = /devise_for :users/
    inject_into_file 'config/routes.rb', routing_code, { :after => sentinel, :verbose => false }
  end

  private  
  
  def better_migration_template (file)
    begin
      migration_template "migrations/#{file}", "db/migrate/#{file}"
      sleep 1 # ensure scripts have different time stamps
    rescue
      puts "  \e[1m\e[34mMigrations\e[0m  " + $!.message
    end
  end
  
end
