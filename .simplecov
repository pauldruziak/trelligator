
SimpleCov.profiles.define 'sinatra' do
  add_filter '/test/'
  add_filter '/.bundle/'
  add_group 'Models', 'lib/'
end
SimpleCov.start 'sinatra'
