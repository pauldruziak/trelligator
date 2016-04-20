# frozen_string_literal: true
module Trelligator
  # Update status on Pull Request
  class GithubPullRequest
    GITHUB_URL_REGEXP = %r{^http(?:s):\/\/github\.com\/[a-z\/-]*\/pull}
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def self.pull_requests_from_trello_card(card_id)
      card = Trello::Card.find card_id
      card.attachments.select { |attachment| attachment.url =~ GITHUB_URL_REGEXP }.map do |pr|
        GithubPullRequest.new(pr.url)
      end
    end

    def update_status(_status)
      raise 'not implemented'
    end
  end
end
