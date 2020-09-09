# frozen_string_literal: true

# By default, only the ApplicationController in a Rails application
# inherits from Jets::Controller::Base. All other controllers inherit
# from ApplicationController. This gives you one class to configure
# things such as request forgery protection and filtering of sensitive
# request parameters.
class ApplicationController < Jets::Controller::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include Error::ErrorHandler
end
