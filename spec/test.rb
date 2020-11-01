require_relative '../lib/mappers/restaurant_mapper'

require 'http'
require 'yaml'
require 'json'
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
GMAP_TOKEN = CONFIG['gmap_token']
poi = Ewa::Restaurant::RestaurantMapper.new(GMAP_TOKEN).poi_details
puts poi
place_name = poi[0]
puts place_name
#data = Ewa::Restaurant::RestaurantMapper.new(GMAP_TOKEN).gmap_place_details(poi)


#puts data