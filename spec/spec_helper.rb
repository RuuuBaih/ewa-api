# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../app/models/mappers/restaurant_mapper'

USERNAME = ''
PROJECT_NAME = 'SOA_project'
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
GMAP_TOKEN = CONFIG['GMAP_TOKEN']

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
PIXNET_CASSETTE_FILE = 'pix_apis'
