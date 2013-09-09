require 'spec_helper'

# This is not your standard looking rspec file.
# It is different in that the generator is being run against the dummy app (i.e. Rails.root in this context).
# The resulting generated files are then tested as part of this test suite.
require 'generators/curate/work/work_generator'
FileUtils.cd(Rails.root)
response = Curate::WorkGenerator.start(%W(spam --force))

sleep(2) if ENV['TRAVIS'] # Because the generator is not completing

spec_filenames = Array(response).flatten.compact.grep(/spec/)

number_of_expected_spec_files = 3
if spec_filenames.size < number_of_expected_spec_files
  banner = "\n" + "*" * 80 + "\n"
  message = banner
  message << "The generator response was not as expected; Since this is outside the context of\n"
  message << "an rspec block, I don't have the usual assertions. Actual response below:\n"
  message << "\n" << response.inspect << "\n"
  message << banner
  raise RuntimeError, message
end

# Because we are adding things to stuff that was already initialized
# (i.e. routes and initializers)
Rails.application.reload_routes!
load Rails.root.join('config/initializers/curate_config.rb')

spec_filenames.each do |spec_path|
  file_path = spec_path.gsub(/^spec\/(.*)_spec.rb$/, 'app/\1.rb')
  require Rails.root.join(file_path) if file_path != spec_path
  begin
    require Rails.root.join(spec_path)
  rescue FactoryGirl::DuplicateDefinitionError => e
    # No worries, this isn't a big deal
  end
end
