require 'rake/testtask'
Dir.glob('lib/tasks/*.rake').each { |r| load r }

Rake::TestTask.new do |t|
  t.pattern = 'test/**/*_test.rb'
end
