# frozen_string_literal: true

require_relative '../app/domain/init'
require_relative '../app/infrastructure/gateways/init'
require_relative '../app/infrastructure/database/init'
require_relative '../init'
require_relative '../spec/helpers/spec_helper'
# require_relative '../app/init'
require 'yaml'

include Ewa
include Ewa::Database
include Restaurant
include Repository

config = YAML.safe_load(File.read('config/secrets.yml'))
token = config['development']['GMAP_TOKEN']
cx = config['development']['CX']

puts RestaurantOrm.first
=begin
restaurants = RestaurantMapper.new(token, cx, "中山區", 2).restaurant_obj_lists
repo_entities = restaurants.map do |restaurant_entity|
  puts restaurant_entity
  Repository::For.entity(restaurant_entity).create(restaurant_entity)
end
#puts repo_entities.inspect
# puts ret
# puts ret.inspect

# puts ret.attributes
=end
