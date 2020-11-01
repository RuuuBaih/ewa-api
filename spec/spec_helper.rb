# frozen_string_literal: true
require 'simplecov'
SimpleCov.start
require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../lib/mappers/restaurant_mapper'

USERNAME = ''
PROJECT_NAME = 'SOA_project'
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
GMAP_TOKEN = CONFIG['gmap_token']
#POI_CORRECT = YAML.safe_load(File.read('spec/fixtures/pixnet_data/poi.yml'))
KEYWORD_CORRECT = YAML.safe_load(File.read('spec/fixtures/pixnet_data/keyword_lists/GUCCI_related_keywords.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
PIXNET_CASSETTE_FILE = 'pix_apis'
