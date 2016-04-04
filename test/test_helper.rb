# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'minitest/pride'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
  config.hook_into :webmock
end

WebMock.disable_net_connect!(allow_localhost: true)

ENV['TRELLO_DEVELOPER_PUBLIC_KEY'] = 'foo'
ENV['TRELLO_MEMBER_TOKEN'] = 'bar'

require_relative '../app'
