task :release_curate => ['release_curate:bump']

namespace :release_curate do
  task :init do
    require 'curate/version'
    require 'bundler/gem_helper'
    class Bundler::GemHelper
      public :guard_clean
      def git_add(path)
        sh("git add #{path}")
      end
      def commit(message)
        yield(self) if block_given?
        sh("git commit -m '#{message}'")
      end
    end
    @gem_helper = Bundler::GemHelper.new
  end
  task :prompt_for_next_version => :init do
    shell = Thor::Shell::Basic.new
    version_slugs = Curate::VERSION.split(".")
    version_slugs[version_slugs.size - 1] = (version_slugs.last.to_i + 1).to_s
    proposed_next_version = version_slugs.join(".")
    @next_version = shell.ask("Current Curate verion #{Curate::VERSION}. Will default to #{proposed_next_version}. Please specify next version or hit Enter to use default:", default: proposed_next_version)
    @next_version = proposed_next_version if @next_version.blank?
  end

  task :guard => :init do
    @gem_helper.guard_clean
  end

  desc 'Make sure the application template is updated'
  task :bump => [:init, :guard, :prompt_for_next_version] do
    version_file_path = Pathname.new(File.expand_path("../../lib/curate/version.rb", __FILE__))
    version_file_contents = version_file_path.read
    out = version_file_contents.sub(Curate::VERSION, @next_version)

    File.open(version_file_path.to_s, 'w+') do |file|
      file.puts out
    end

    Curate::VERSION = @next_version

    application_template_path = Pathname.new(File.expand_path("../../lib/generators/curate/", __FILE__))
    application_template_erb_path = application_template_path.join("application_template.rb.erb")
    application_template_output_path = application_template_path.join("application_template.rb")

    buffer = ERB.new(application_template_erb_path.read).result(binding)
    File.open(application_template_output_path.to_s, 'w+') do |file|
      file.puts buffer
    end

    @gem_helper.commit("Bumping to version #{@next_version}") do |helper|
      helper.git_add(version_file_path.to_s)
      helper.git_add(application_template_output_path.to_s)
    end
  end
end
