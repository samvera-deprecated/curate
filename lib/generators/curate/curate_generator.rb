# encoding: utf-8

# -*- encoding : utf-8 -*-
require 'rails/generators'
require 'rails/generators/migration'


class CurateGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)

  class_option :with_doi, default: false, type: :boolean

  desc """
This generator makes the following changes to your application:
 1. Runs required generators
 2. Adds curate behaviors to ApplicationController
 3. Adds the curate routes
 4. Adds the curate abilities
 5. Adds a user migration
 6. Adds views for devise
       """

  def run_required_generators
    generate "blacklight --devise"
    remove_dir('app/views/devise')
    generate "hydra:head -f"
    generate "sufia:models:install#{options[:force] ? ' -f' : ''}"
    generate "hydra:remote_identifier:install#{options[:force] ? ' -f' : ''}"
  end

  # Add behaviors to the application controller
  def inject_controller_behavior
    controller_name = "ApplicationController"
    file_path = "app/controllers/application_controller.rb"
    if File.exists?(file_path)
      insert_into_file file_path, :after => 'include Blacklight::Controller' do
        "\n  include CurateController\n"
      end
      gsub_file file_path, "layout 'blacklight'", ""
    else
      puts "     \e[31mFailure\e[0m  Could not find #{file_path}.  To add Curate behaviors to your ApplicationController, you must include the CurateController module in the ApplicationController class definition."

    end
  end

  # Setup the database migrations
  def copy_migrations
    rake 'curate_engine:install:migrations'
  end

  # The engine routes have to come after the devise routes so that /users/sign_in will work
  def inject_routes
    routing_code = "\n  curate_for\n"
    sentinel = /devise_for +:users.*$/
    inject_into_file 'config/routes.rb', routing_code, { :after => sentinel, :verbose => false }
    gsub_file 'config/routes.rb', /^\s+root.+$/, "  root 'catalog#index'"
  end


  def create_search_config
    create_file('config/search_config.yml', "development:\ntest:\nproduction:\n", force: true)
    search_options = "  catalog:\n  people:\n"
    inject_into_file 'config/search_config.yml', search_options, after: /development\:\n/, force: true
    inject_into_file 'config/search_config.yml', search_options, after: /test\:\n/, force: true
    inject_into_file 'config/search_config.yml', search_options, after: /production\:\n/, force: true
  end


  DEFAULT_CURATION_CONCERNS = [:generic_works, :datasets, :articles, :etds, :images, :documents]

  def create_curate_config
    initializer 'curate_config.rb' do
      data = []
      data << "Curate.configure do |config|"
      DEFAULT_CURATION_CONCERNS.each_with_object(data) {|curation_concern, mem|
        mem << "  config.register_curation_concern :#{curation_concern.to_s.singularize}"
      }
      data << "  # # You can override curate's antivirus runner by configuring a lambda \(or"
      data << "  # # object that responds to call\)"
      data << "  # config.default_antivirus_instance = lambda {|filename| … }"
      data << ""
      data << "  # # Used for constructing permanent URLs"
      data << "  # config.application_root_url = 'https://repository.higher.edu/'"
      data << ""
      data << "  # # Used to load values for constructing SOLR searches"
      data << "  search_config_file = File.join(Rails.root, 'config', 'search_config.yml')"
      data << "  config.search_config = YAML::load(File.open(search_config_file))[Rails.env].with_indifferent_access"
      data << ""
      data << "  # # Override the file characterization runner that is used"
      data << "  # config.characterization_runner = lambda {|filename| … }"
      data << "end"
      data << ""
      data.join("\n")
    end
  end

  def register_remote_identifiers
    if options.fetch('with_doi', false)
      generate 'curate:work:with_doi', DEFAULT_CURATION_CONCERNS.collect(&:to_s).join(" ")
    end
  end

  # This enables our registrations controller to run the after_update_path_for hook.
  def update_devise_route
    gsub_file 'config/routes.rb', /^\s+devise_for :users\s*$/ do
      %(    devise_for :users, controllers: { sessions: :sessions, registrations: :registrations}\n\n)
    end
  end

  def create_manager_usernames
    create_file('config/manager_usernames.yml', "development:\n  manager_usernames:\n  - manager@example.com\ntest:\n  manager_usernames:\n  - manager@example.com\nproduction:\n  manager_usernames:\n  - manager@example.com\n")
  end

  def create_recipients_list
    create_file('config/recipients_list.yml', "---\n- hello@world.com\n")
  end

  def create_browse_everything_providers
    create_file('config/browse_everything_providers.yml', "---\nfile_system:\n  :home: /<location for server file drop>\nsky_drive:\n  :client_id: <your client id>\n  :client_secret: <your client secret>\nbox:\n  :client_id: <your client id>\n  :client_secret: <your client secret>\ndrop_box:\n  :app_key: <your client id>\n  :app_secret: <your app secret>\ngoogle_drive:\n  :client_id: <your client id>\n  :client_secret: <your client secret>\n")
  end

  def inject_curate_user
    inject_into_file 'app/models/user.rb', after: /include Sufia\:\:User.*$/ do
      "\n  include Curate::UserBehavior\n"
    end
  end

  def inject_curate_ability
    inject_into_file 'app/models/ability.rb', :after => /Hydra::Ability\s*\n/ do
      "  include Curate::Ability\n\n"
    end
  end

  def remove_catalog_controller
    say_status("warning", "Removing Blacklight's generated CatalogController...It will cause you grief", :yellow)
    remove_file('app/controllers/catalog_controller.rb')
  end

  def update_assets
    insert_into_file 'app/assets/stylesheets/application.css', before: /^ *\*= +require_tree +\. *$/ do
      " *= require curate\n"
    end
    insert_into_file "app/assets/javascripts/application.js", :before => '//= require_tree .' do
      "//= require curate\n"
    end
  end

  def remove_blacklight
    remove_file('app/assets/stylesheets/blacklight.css.scss')
  end

  def run_migrations
    rake "db:migrate"
  end

  def install_readme
    readme 'README.md'
  end

end
