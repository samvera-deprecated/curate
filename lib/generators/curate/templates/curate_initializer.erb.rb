Curate.configure do |config|
  <%= default_curation_concerns.inspect %>
  <% default_curation_concerns.each do |curation_concern| %>
  config.register_curation_concern :<%= curation_concern.to_s.singularize %>
  <% end %>

  # # You can override curate's antivirus runner by configuring a lambda (or 
  # # object that responds to call)
  # config.default_antivirus_instance = lambda {|filename| … }

  # # Used for constructing permanent URLs
  # config.application_root_url = "https://repository.higher.edu/"

  # # Override the file characterization runner that is used
  # config.characterization_runner = lambda {|filename| … }
end
