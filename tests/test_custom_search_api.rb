# frozen_string_literal: true

require_relative '../app/infrastructure/gateways/custom_search_api'
require 'yaml'

include Ewa
include CustomSearch

config = YAML.safe_load(File.read('config/secrets.yml'))

puts "GMAP_TOKEN"
puts config['development']['GMAP_TOKEN']
puts "SEARCH_ENGINE"
puts config['development']['SEARCH_ENGINE']

search_photo = CustomSearchApi.new(config['development']['GMAP_TOKEN'], '私宅打邊爐料理', config['development']['SEARCH_ENGINE']).search_photo
puts search_photo
puts search_photo.inspect