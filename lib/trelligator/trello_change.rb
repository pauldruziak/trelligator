# frozen_string_literal: true
module Trelligator
  # Wrapper for Trello Webhook Response
  class TrelloChange
    attr_reader :action, :list_order

    def self.from_response(body)
      data = JSON.parse body
      new(data)
    end

    def initialize(options, list_order: ListOrder.new)
      @action = Hash(options['action'])
      @list_order = list_order
    end

    def card_id
      action['data']['card']['id']
    end

    def status_changed?
      card_updated? && list_before.present? && list_after.present?
    end

    def description
      "Moved from #{list_before} to #{list_after} by #{member}"
    end

    def state
      if finished?
        'success'
      elsif moved_backward?
        'failure'
      else
        'pending'
      end
    end

    private

    def card_updated?
      action['type'] == 'updateCard'
    end

    def list_before
      action['data']['listBefore']
    end

    def list_after
      action['data']['listAfter']
    end

    def member
      action['memberCreator']['fullName']
    end

    def finished?
      position_for_list(list_after).zero?
    end

    def moved_backward?
      position_for_list(list_after) > position_for_list(list_before)
    end

    def position_for_list(list_name)
      list_order.position_for(list_name)
    end

    # Simple class to manage order of lists. In future it should be configured by user for every Trello board.
    class ListOrder
      attr_reader :list_order
      def initialize
        @list_order = [
          'Ready for deploy',
          'QA',
          'Code Review',
          'In Progress'
        ].freeze
      end

      def position_for(list_name)
        list_order.index(list_name) || -1
      end
    end
  end
end
