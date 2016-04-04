# frozen_string_literal: true
module TrelloFixtures
  def trello_response(name)
    @trello_response ||= YAML.load_file(File.join(__dir__, 'trello_response.yml'))
    @trello_response[name.to_s]
  end
end
