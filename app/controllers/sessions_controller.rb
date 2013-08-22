class SessionsController < Devise::SessionsController
  include Curate::ThemedLayoutController
  with_themed_layout '1_column'
end
