# frozen_string_literal: true
require './app'

namespace :trello do
  desc 'Create new webhook'
  task :create_webhook do
    raise 'Setup CALLBACK_URL varibale' if ENV['CALLBACK_URL'].nil?
    webhook = Trello::Webhook.create(
      description: 'Callback for Trelligator',
      id_model: '565e2d28df59732d0629d336',
      callback_url: ENV['CALLBACK_URL']
    )
    puts "Webhook id: #{webhook.id} and status: #{webhook.active}"
  end

  desc 'List of boards'
  task :boards do
    puts Trello::Board.all.map { |board| "#{board.id}: #{board.name}" }
  end
end
