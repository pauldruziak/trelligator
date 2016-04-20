# frozen_string_literal: true
require_relative '../../test_helper.rb'

module Trelligator
  class GithubPullRequestTest < Minitest::Test
    def test_pull_requests
      VCR.use_cassette('pull_requests', record: :none) do
        pull_requests = GithubPullRequest.pull_requests_from_trello_card '56fd1c7dc5743902e4ad40a4'
        pr = pull_requests.first

        assert pr.is_a?(GithubPullRequest),
               "Should be GithubPullRequest, not #{pr.class.name}"

        assert pr.url, 'https://github.com/gothamtechlabs/crm-web/pull/2795'
      end
    end
  end
end
