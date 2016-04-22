# frozen_string_literal: true
require File.expand_path '../test_helper.rb', __FILE__
require 'rack/test'

include Rack::Test::Methods

def app
  Sinatra::Application
end

class MainAppTest < Minitest::Test
  def test_displays_main_page
    get '/'
    assert last_response.ok?
    assert last_response.body.include?('Hello World')
  end

  def test_check_webhook_url
    head '/webhook'
    assert last_response.ok?
  end
end

class WebhookWithStatusChangedTest < Minitest::Test
  include ::TrelloFixtures

  def test_webhook
    mock = MiniTest::Mock.new
    mock.expect(:update_status, true) do |args|
      args[:state] == 'pending' && args[:description] == "James Bond moved to 'QA' from 'Code Review'"
    end
    VCR.use_cassette('pull_requests', record: :none) do
      Trelligator::GithubPullRequest.stub(:new, mock) do
        post '/webhook', trello_response(:valid).to_json
      end
    end
    assert last_response.ok?
  end
end
