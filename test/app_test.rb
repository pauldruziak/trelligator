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
  def trello_response
    {
      action: {
        type: 'updateCard',
        data: {
          listBefore: 'QA',
          listAfter: 'Review',
          card: { id: '56fd1c7dc5743902e4ad40a4' }
        },
        memberCreator: { fullName: 'James Bond' }
      }
    }
  end

  def test_webhook
    mock = MiniTest::Mock.new
    mock.expect(:update, nil) do |status|
      status.list_before == 'QA' && status.list_after == 'Review'
    end
    VCR.use_cassette('pull_requests', record: :none) do
      Trelligator::GithubPullRequest.stub(:new, mock) do
        post '/webhook', trello_response.to_json
      end
    end
    assert last_response.ok?
  end
end
