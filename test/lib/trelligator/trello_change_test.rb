# frozen_string_literal: true
require_relative '../../test_helper.rb'

module Trelligator
  class TrelloChangeParserTest < Minitest::Test
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

    def test_parser
      trello = TrelloChange.parse(trello_response.to_json)

      assert trello.is_a?(TrelloChange), "It should be TrelloChange, not #{trello.class.name}"
    end

    def test_status_changed
      trello = TrelloChange.parse(trello_response.to_json)

      assert trello.status_changed?, 'Status should be changed'
    end

    def test_status_not_changed_becuase_of_action_type
      other_type = trello_response.deep_merge(action: { type: 'somethingElse' })
      trello = TrelloChange.parse(other_type.to_json)

      assert !trello.status_changed?, 'Status should not be changed'
    end

    def test_status_not_changed_because_of_missing_info_about_columns
      without_columns = trello_response.deep_merge(action: { data: { listAfter: nil } })
      trello = TrelloChange.parse(without_columns.to_json)

      assert without_columns[:action][:data][:listAfter].blank?
      assert !trello.status_changed?, 'Status should not be changed'
    end

    def test_pull_requests
      trello = TrelloChange.parse trello_response.to_json

      VCR.use_cassette('pull_requests', record: :none) do
        pr = trello.pull_requests.first
        assert pr.is_a?(GithubPullRequest),
               "Should be GithubPullRequest, not #{trello.class.name}"

        assert pr.url, 'https://github.com/gothamtechlabs/crm-web/pull/2795'
      end
    end
  end
end
