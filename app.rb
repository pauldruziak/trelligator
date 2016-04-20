# frozen_string_literal: true
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
    Trelligator::GithubPullRequest.pull_requests_from_trello_card(trello.card_id).each do |pr|
      pr.update trello.status
    end
  end
  status 200
end
