# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

=begin
# require_relative '../app/models/mappers/restaurant_mapper'
require_relative '../app/models/mappers/article_mapper'
require_relative '../app/models/entities/article'
require_relative '../app/models/mappers/restaurant_mapper'
require_relative '../app/models/entities/restaurant'
require_relative '../app/models/mappers/review_mapper'
require_relative '../app/models/entities/review'
=end

require_relative "../app/models/init.rb"
require_relative "../app/controllers/init.rb"
require_relative "../config/init.rb"

USERNAME = ''
PROJECT_NAME = 'SOA_project'
GMAP_TOKEN = Ewa::App.config.GMAP_TOKEN

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'apis'