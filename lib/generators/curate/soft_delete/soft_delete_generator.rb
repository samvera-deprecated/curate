require 'rails/generators'

class Curate::SoftDeleteGenerator < Rails::Generators::Base
  source_root File.expand_path('../', __FILE__)

  def install
    template 'active_fedora_soft_delete_monkey_patch.rb', 'config/initializers/active_fedora_soft_delete_monkey_patch.rb'
    template 'deny-d-objects-and-datastreams.xml', 'jetty/fedora/default/data/fedora-xacml-policies/repository-policies/deny-d-objects-and-datastreams.xml'
    template 'deny-purge.xml', 'jetty/fedora/default/data/fedora-xacml-policies/repository-policies/deny-purge.xml'
    template 'permit-describerepository.xml', 'jetty/fedora/default/data/fedora-xacml-policies/repository-policies/permit-describerepository.xml'
  end
end
