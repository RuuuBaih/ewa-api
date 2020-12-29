# frozen_string_literal: true

# don't move the order, spec helper should be first require
require_relative '../spec/helpers/spec_helper'
require_relative '../app/infrastructure/database/init'
require 'yaml'

include Ewa
include Ewa::Database
include Restaurant
include Repository

config = YAML.safe_load(File.read('config/secrets.yml'))
token = config['development']['GMAP_TOKEN']
cx = config['development']['CX']
restaurants = RestaurantMapper.new(token, cx, "中山區", 4).restaurant_obj_lists
repo_entities = restaurants.map do |restaurant_entity|
  puts restaurant_entity.inspect
  Repository::For.entity(restaurant_entity).create(restaurant_entity)
end
puts repo_entities.inspect
