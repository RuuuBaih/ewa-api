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

# For testing create towns into db
town_entities = Repository::Towns.create_first_time
puts town_entities.inspect

# For testing if search_times > 5, call RestaurantMapper for more 9 poi restaurant records
# search_time limit can be set (not 5)
whole_status = Repository::Towns.check_update_status('中山區', 5)
town_entity = whole_status[:entity].id
status = whole_status[:status]
if status
  # return to user random 9 results from db (now use all to replace)
  puts Repository::Restaurants.all.sample(9).inspect
  # puts Repository::Restaurants.find_by_town_money(town_entity.town, min_mon, max_mon)
  # put new restaurant infos to db
  new_page = town_entity.page + 1
  town_name = town_entity.town_name
  restaurants = RestaurantMapper.new(token, cx, town_name, new_page).restaurant_obj_lists
  repo_entities = restaurants.map do |restaurant_entity|
    puts restaurant_entity
    Repository::For.entity(restaurant_entity).create(restaurant_entity)
  end
  # update new page and restaurant search nums to db town table
  Repository::Towns.update_page(town_name)
  Repository::Towns.update_search(town_name)

  # check if new infos are put into db
  puts Repository::Restaurants.all.length
else
  # return to user random 9 results from db
  puts Repository::Restaurants.all.sample(9).inspect
end
