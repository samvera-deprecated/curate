task :release => ['release:update_template']

namespace :release do
  task :guard do
    require 'bundler/gem_helper'
    class Bundler::GemHelper
      public :guard_clean
      def commit_file(path, message)
        sh("git add #{path} && git commit -m '#{message}'")
      end
    end
    @gem_helper = Bundler::GemHelper.new
    @gem_helper.guard_clean
  end

  desc 'Make sure the application template is updated'
  task :update_template => :guard do
    require 'curate/version'
    application_template_path = Pathname.new(File.expand_path("../../lib/generators/curate/", __FILE__))
    application_template_erb_path = application_template_path.join("application_template.rb.erb")
    application_template_output_path = application_template_path.join("application_template.rb")

    buffer = ERB.new(application_template_erb_path.read).result(binding)
    File.open(application_template_output_path.to_s, 'w+') do |file|
      file.puts buffer
    end

    @gem_helper.commit_file(application_template_output_path.to_s, "Updating application_template for v#{Curate::VERSION}")
  end
end
