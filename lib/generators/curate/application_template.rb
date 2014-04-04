def with_git(message)
  yield if block_given?
  if ! options.fetch('skip_git', false)
    git :init
    git add: '.'
    git commit: "-a -m '#{message}'"
  end
end
def yes_with_banner?(message, banner = "*" * 80)
  yes?("\n#{banner}\n\n#{message}\n#{banner}\nType y(es) to confirm:")
end
def source_paths
  Array(super) +
      [File.join(File.expand_path(File.dirname(__FILE__)),'predicate_mapping')]
end


with_git("Initial commit")

with_git("Adding curate gem") do
  gem 'curate', "~> 0.6.6"
end


copy_file 'predicate_mappings.yml', 'config/predicate_mappings.yml'


HELPFUL_DEVELOPMENT_TOOLS =
  <<-QUESTION_TO_ASK
Would you like to include some helfpul development tools? (i.e. better_errors, binding_of_caller, quiet_assets)

http://rubygems.org/gems/better_errors
http://rubygems.org/gems/quiet_assets
http://rubygems.org/gems/binding_of_caller
QUESTION_TO_ASK

if yes_with_banner?(HELPFUL_DEVELOPMENT_TOOLS)
  with_git("Adding better_errors gem") do
    gem 'better_errors', group: :development
  end

  with_git("Adding binding_of_caller gem") do
    gem 'binding_of_caller', group: :development
  end

  with_git("Adding quiet_assets gem") do
    gem 'quiet_assets', group: :development
  end

end

USE_RUBY_RACER =
  <<-QUESTION_TO_ASK
Would you like to include the Ruby Racer gem? (Needed in some Linux environments)

More information at http://github.com/cowboyd/therubyracer
QUESTION_TO_ASK

if yes_with_banner?(USE_RUBY_RACER)
  with_git("Adding Ruby Racer gem") do
    gem 'therubyracer', platforms: :ruby
  end

end

with_git("Results of `bundle install`") do
  run 'bundle install'
end

DOI_QUESTION =
  <<-QUESTION_TO_ASK
Would you like to allow remote minting of Digital Object Identifiers (DOI)s?

More information at http://simple.wikipedia.org/wiki/Doi
QUESTION_TO_ASK

with_doi_answer = yes_with_banner?(DOI_QUESTION)

command = [:curate, "--with-doi=#{with_doi_answer}"]

with_git("Install curate gem with#{with_doi_answer ? '' : 'out' } DOI support\n\nWith generator: #{command.join(' ')}") do
  generate(*command)
end

JETTY_QUESTION =
  <<-QUESTION_TO_ASK
Would you like to use jettywrapper for your SOLR and Fedora?

More information at https://github.com/projecthydra/jettywrapper/
QUESTION_TO_ASK

if yes_with_banner?(JETTY_QUESTION)
  with_git("Configuring to ignore jetty dir") do
    append_file '.gitignore', "\njetty/\n"
  end

  with_git("Installing jettywrapper") do
    gem 'jettywrapper', group: [:development, :test]
    run 'bundle install'
  end

  with_git("Downloading jettywrapper") do
    if yes_with_banner?("Would you like to download and unzip jetty now?\n\nThis will take quite awhile based on download speeds.")
      rake "jetty:download"
      rake "jetty:unzip"
      rake "jetty:config"
      if yes_with_banner?("Would you like to turn on soft deleting of works?\n\nThis will preserve deleted objects in the Fedora repository while preventing the works from being displayed in the application.")
        generate "curate:soft_delete"
      end
    end
  end
end

with_git("Installing RSpec files with curate support") do
  if yes_with_banner?("Would you like to include support for RSpec testing?\n\nThis is needed if you want to use spec tests for your custom code.")
    generate "rspec:install"
    inject_into_file 'spec/spec_helper.rb', "\nrequire 'curate/spec_support'", :after => "require 'rspec/autorun'"
  end
end
