# frozen_string_literal: true

# By default, only the ApplicationController in a Rails application
# inherits from Jets::Controller::Base. All other controllers inherit
# from ApplicationController. This gives you one class to configure
# things such as request forgery protection and filtering of sensitive
# request parameters.
class ApplicationController < Jets::Controller::Base
end
