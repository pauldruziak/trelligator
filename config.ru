# frozen_string_literal: true
require './app'
configure { set :server, :puma }
run Sinatra::Application
