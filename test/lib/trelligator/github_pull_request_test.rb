# frozen_string_literal: true
require_relative '../../test_helper.rb'

module Trelligator
  class GithubPullRequestTest < Minitest::Test
    def test_pull_requests
      VCR.use_cassette('pull_requests', record: :none) do
        card = Trello::Card.find '56fd1c7dc5743902e4ad40a4'
        pull_requests = GithubPullRequest.from_trello_card card
        pr = pull_requests.first

        assert pr.is_a?(GithubPullRequest),
               "Should be GithubPullRequest, not #{pr.class.name}"

        assert_equal pr.url, 'https://github.com/gothamtechlabs/crm-web/pull/2795'
      end
    end

    def test_repo_parser
      pr = GithubPullRequest.new 'https://github.com/gothamtechlabs/crm-web/pull/2795'

      assert_equal pr.repo, 'gothamtechlabs/crm-web'
    end

    def test_pr_number_parser
      pr = GithubPullRequest.new 'https://github.com/gothamtechlabs/crm-web/pull/2795'

      assert_equal pr.pr_number, '2795'
    end

    def test_pr_sha
      VCR.use_cassette('load_pull_request', record: :none) do
        pr = GithubPullRequest.new 'https://github.com/gothamtechlabs/crm-web/pull/2795'

        assert_equal pr.sha, 'b9218ccbcc107cbc551f62c1c632ead07bc98763'
      end
    end
  end
end
