namespace :spec do
  desc 'Show the source location of rspec matchers'
  task :show_matchers => [:generate] do
    require File.expand_path("../../spec/internal/config/environment.rb",  __FILE__)

    $SHOW_MATCHERS = {}

    require File.expand_path('../../spec/matchers', __FILE__)


    rspec_matcher_namespaces = [RSpec::Matchers]
    if defined?(RSpec::Rails::Matchers)
      rspec_matcher_namespaces << RSpec::Rails::Matchers
    end

    rspec_matcher_namespaces.each do |namespace|
      namespace.instance_methods.sort.each do |method_name|
        # If RSpec::Matchers.matcher or RSpec::Matchers.matcher was used the
        # method_name will already be in the $MATCHER hash
        unless $SHOW_MATCHERS.has_key?(method_name)
          $SHOW_MATCHERS[method_name] = namespace.instance_method(method_name).source_location
        end
      end
    end

    method_name_size = 0
    $SHOW_MATCHERS.each{|k,v|
      method_name_size = k.length if k.length > method_name_size
    }

    $SHOW_MATCHERS.sort.each {|k,v|
      puts "%-#{method_name_size}s\t%s" % [k, v.join(":")]
    }
  end
end
