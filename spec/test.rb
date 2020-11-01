require_relative '../lib/mappers/restaurant_mapper'

require 'http'
require 'yaml'
require 'json'
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
GMAP_TOKEN = CONFIG['gmap_token']
poi = Ewa::Restaurant::RestaurantMapper.new(GMAP_TOKEN).poi_details
puts poi
poi_hash = Ewa::Restaurant::RestaurantMapper.new(GMAP_TOKEN).restaurant_obj_lists
data = Ewa::Restaurant::RestaurantMapper.new(GMAP_TOKEN).gmap_place_details(poi)


puts data