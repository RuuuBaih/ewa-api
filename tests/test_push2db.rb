# frozen_string_literal: true

require 'yaml'
require_relative '../app/domain/init'
require_relative '../app/infrastructure/gateways/init'
require_relative '../app/infrastructure/database/init'

# heroku rake console (under lines)
include Ewa
include Ewa::Database
include Restaurant
include Repository
include Mapper

# config = YAML.safe_load(File.read('config/secrets.yml'))

# restaurant_entities = Restaurant::RestaurantMapper.new(config['development']['GMAP_TOKEN']).restaurant_obj_lists
restaurant_entities = Restaurant::RestaurantMapper.new(App.config.GMAP_TOKEN).restaurant_obj_lists

restaurant_repo_entities = restaurant_entities.map do |restaurant_entity|
  Repository::For.entity(restaurant_entity).create(restaurant_entity)
end

puts restaurant_repo_entities.first
