# frozen_string_literal: true
require_relative '../../test_helper.rb'

module Trelligator
  class TrelloChangeParserTest < Minitest::Test
    include ::TrelloFixtures

    def test_parser
      trello = TrelloChange.parse(trello_response(:valid).to_json)

      assert trello.is_a?(TrelloChange), "It should be TrelloChange, not #{trello.class.name}"
    end

    def test_status_changed
      trello = TrelloChange.parse(trello_response(:valid).to_json)

      assert trello.status_changed?, 'Status should be changed'
    end

    def test_status_not_changed_becuase_of_action_type
      trello = TrelloChange.parse(trello_response(:wrong_type).to_json)

      assert !trello.status_changed?, 'Status should not be changed'
    end

    def test_status_not_changed_because_of_missing_info_about_columns
      trello = TrelloChange.parse(trello_response(:without_columns).to_json)

      assert trello_response(:without_columns)['action']['data']['listAfter'].blank?
      assert !trello.status_changed?, 'Status should not be changed'
    end
  end
end
