# frozen_string_literal: true

#require_relative '../app/domain/init'
#require_relative '../app/infrastructure/gateways/init'
require_relative '../app/init'
require 'yaml'

include Ewa
include Ewa::Database
include Restaurant

config = YAML.safe_load(File.read('config/secrets.yml'))

restaurant = RestaurantMapper.new(config['development']["GMAP_TOKEN"]).restaurant_obj_lists
puts restaurant.inspect
# puts ret
#puts ret.inspect

# puts ret.attributes
