# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

# # require_relative '../app/models/mappers/restaurant_mapper'
# require_relative '../app/models/mappers/article_mapper'
# require_relative '../app/models/entities/article'
# require_relative '../app/models/mappers/restaurant_mapper'
# require_relative '../app/models/entities/restaurant'
# require_relative '../app/models/mappers/review_mapper'
# require_relative '../app/models/entities/review'
=begin
require_relative '../app/models/init'
require_relative '../app/controllers/init'
require_relative '../config/init'
=end
require_relative '../../init'

USERNAME = ''
PROJECT_NAME = 'SOA_project'
GMAP_TOKEN = Ewa::App.config.GMAP_TOKEN

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'apis'