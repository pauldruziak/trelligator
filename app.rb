require 'sinatra'
require 'trello'
require_relative 'lib/trelligator'

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
  trello = Trelligator::TrelloChange.parse(request.body.read)
  if trello.status_changed?
    trello.pull_requests.each { |pr| pr.update trello.status }
  end
  status 200
end
