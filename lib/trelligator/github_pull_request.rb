# frozen_string_literal: true
module Trelligator
  # Update status on Pull Request
  class GithubPullRequest
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def update_status(_status)
      raise 'not implemented'
    end
  end
end
