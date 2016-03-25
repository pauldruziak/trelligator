require './app'
configure { set :server, :puma }
run Sinatra::Application
