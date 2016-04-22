# frozen_string_literal: true
require_relative '../../test_helper.rb'

module Trelligator
  class TrelloChangeTest < Minitest::Test
    include ::TrelloFixtures

    def test_parser
      trello = TrelloChange.from_response(trello_response(:valid).to_json)

      assert trello.is_a?(TrelloChange), "It should be TrelloChange, not #{trello.class.name}"
    end

    def test_status_changed
      trello = TrelloChange.from_response(trello_response(:valid).to_json)

      assert trello.status_changed?, 'Status should be changed'
    end

    def test_status_not_changed_becuase_of_action_type
      trello = TrelloChange.from_response(trello_response(:wrong_type).to_json)

      assert !trello.status_changed?, 'Status should not be changed'
    end

    def test_status_not_changed_because_of_missing_info_about_columns
      trello = TrelloChange.from_response(trello_response(:without_columns).to_json)

      assert trello_response(:without_columns)['action']['data']['listAfter'].blank?
      assert !trello.status_changed?, 'Status should not be changed'
    end

    def test_state_success
      trello = build_trello_change(after: 'Ready for deploy')

      assert_equal trello.state, 'success'
    end

    def test_state_pending
      trello = build_trello_change(after: 'QA', before: 'Code Review')

      assert_equal trello.state, 'pending'
    end

    def test_state_failure
      trello = build_trello_change(after: 'Code Review', before: 'QA')

      assert_equal trello.state, 'failure'
    end

    def test_state_pending_when_list_unknown
      trello = build_trello_change(after: 'Unknown', before: 'QA')

      assert_equal trello.state, 'pending'
    end

    def build_trello_change(after:, before: '')
      TrelloChange.new(
        'action' => { 'data' => { 'listAfter' => { 'name' => after }, 'listBefore' => { 'name' => before } } }
      )
    end
  end
end
