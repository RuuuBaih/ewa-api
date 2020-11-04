# frozen_string_literal: true

require_relative 'restaurant_mapper'
require 'yaml'

include Ewa
include Restaurant

config = YAML.safe_load(File.read('config/secrets.yml'))
# data = RestaurantMapper.new(config['GMAP_TOKEN']).get_restaurant_obj_lists

new_res = RestaurantMapper.new(config['GMAP_TOKEN'])
ret = new_res.restaurant_obj_lists
puts ret.class
puts ret.inspect
#ret = RestaurantMapper::BuildRestaurantEntity.new(data).build_entity
#puts ret
#puts ret.inspect

# puts ret.attributes
