module Trelligator
  # Wrapper for Trello Webhook Response
  class TrelloChange
    attr_reader :action
    def self.parse(body)
      data = JSON.parse body
      new(data)
    end

    def initialize(options)
      @action = Hash(options['action'])
    end

    def status_changed?
      card_updated? && list_before.present? && list_after.present?
    end

    def card_updated?
      action['type'] == 'updateCard'
    end

    def status_message
      "Moved from #{list_before} to #{list_after} by #{member}"
    end

    def status
      @status ||= TrelloStatus.new(
        card_id: card_id,
        list_before: list_before,
        list_after: list_after,
        member: member
      )
    end

    def pull_requests
      card = Trello::Card.find card_id
      card.attachments.select { |a| a.url =~ %r{^http(?:s):\/\/github\.com\/[a-z\/-]*\/pull} }.map do |a|
        GithubPullRequest.new(a.url)
      end
    end

    private

    def card_id
      action['data']['card']['id']
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
  end
end
