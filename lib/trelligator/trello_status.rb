# frozen_string_literal: true
module Trelligator
  # Trello status object
  class TrelloStatus
    attr_reader :card_id, :list_before, :list_after, :member

    def initialize(card_id:, list_before:, list_after:, member:)
      @card_id = card_id
      @list_before = list_before
      @list_after = list_after
      @member = member
    end
  end
end
