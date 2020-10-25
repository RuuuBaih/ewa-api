# frozen_string_literal: true

require 'rake/testtask'

CODE = 'lib/'

task :default do
  puts `rake -T`
end

desc 'run tests'
task :spec do
  sh 'ruby spec/pixnet_api_spec.rb'
end

namespace :vcr do
  desc 'delete pix fixtures'
  task :wipe_keyword do
    sh 'rm spec/fixtures/pixnet_data/keyword_lists/*.yml' do |ok, _|
      puts(ok ? 'pix keyword fixtures deleted' : 'No pix keyword fixtues found')
    end
  end
  task :wipe_poi do
    sh 'rm spec/fixtures/pixnet_data/poi_lists/*.yml' do |ok, _|
      puts(ok ? 'pix poi deleted' : 'No pix poi found')
    end
  end
end

namespace :quality do
  desc 'run all quality checks'
  task all: %i[rubocop reek flog]

  task :rubocop do
    sh 'rubocop'
  end

  task :reek do
    sh 'reek'
  end

  task :flog do
    sh "flog #{CODE}"
  end
end
