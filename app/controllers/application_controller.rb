class ApplicationController < ActionController::Base

  #   Umbrella controller for the app. Most functionality is in
  #   the controllers for users, sessions, products and sales. 

  #   Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception

  include SessionsHelper

end
