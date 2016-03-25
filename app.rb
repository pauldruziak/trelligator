require 'sinatra'

get '/' do
  'Hello World!'
end

post '/webhook' do
  p params
  status 200
end
