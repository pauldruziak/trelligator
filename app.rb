require 'sinatra'
require 'trello'

Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_DEVELOPER_PUBLIC_KEY']
  config.member_token = ENV['TRELLO_MEMBER_TOKEN']
end

get '/' do
  'Hello World!'
end

head '/webhook' do
  'HEAD'
end

post '/webhook' do
  p params
  status 200
end
