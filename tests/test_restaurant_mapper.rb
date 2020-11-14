# frozen_string_literal: true

require_relative '../app/models/mappers/restaurant_mapper'
require 'yaml'

include Ewa
include Restaurant

config = YAML.safe_load(File.read('config/secrets.yml'))

restaurant = RestaurantMapper.new(config['development']["GMAP_TOKEN"]).restaurant_obj_lists
puts restaurant
# puts ret
#puts ret.inspect

# puts ret.attributes
