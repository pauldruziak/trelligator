# frozen_string_literal: true
module Trelligator
  # Update status on Pull Request
  class GithubPullRequest
    GITHUB_URL_REGEXP = %r{^http(?:s):\/\/github\.com\/[a-z\/-]*\/pull}
    REPO_REGEXP = %r{[a-z-]*\/[a-z-]*(?=\/pull)}
    PR_NUMBER_REGEXP = /\d+$/

    attr_reader :url, :github_client

    def initialize(url, github_client: Octokit::Client.new)
      @url = url
      @github_client = github_client
    end

    def self.from_trello_card(card)
      card.attachments.select { |attachment| attachment.url =~ GITHUB_URL_REGEXP }.map do |pr|
        GithubPullRequest.new(pr.url)
      end
    end

    def update(card)
      update_status state: card.state, description: card.description
      update_label label: label_for(card.current_list)
    end

    def update_status(state: 'pending', description:)
      github_client.create_status(
        repo,
        sha,
        state,
        'description' => description, 'context' => 'trelligator'
      )
    end

    def update_label(label:)
      github_client.replace_all_labels(repo, pr_number, [label])
    end

    def repo
      url.match(REPO_REGEXP).to_s
    end

    def pr_number
      url.match(PR_NUMBER_REGEXP).to_s
    end

    def sha
      @sha ||= github_client.pull_request(repo, pr_number)['head']['sha'].to_s
    end

    def label_for(list)
      {
        'Ready for deploy' => 'ready for deploy',
        'QA' => 'qa',
        'Code Review' => 'code review',
        'In Progress' => 'wip'
      }.fetch(list) { 'wip' }
    end
  end
end
