# frozen_string_literal: true
require 'sinatra'
require 'trello'
require_relative 'lib/trelligator'

Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_DEVELOPER_PUBLIC_KEY']
  config.member_token = ENV['TRELLO_MEMBER_TOKEN']
end

Octokit.configure do |config|
  config.access_token = ENV['GITHUB_ACCESS_TOKEN']
end

get '/' do
  'Hello World!'
end

head '/webhook' do
  'HEAD'
end

post '/webhook' do
  trello = Trelligator::TrelloChange.from_response(request.body.read)
  if trello.status_changed?
    card = Trello::Card.find trello.card_id
    Trelligator::GithubPullRequest.from_trello_card(card).each do |pr|
      pr.update trello
    end
  end
  status 200
end
