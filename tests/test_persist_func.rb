# frozen_string_literal: true

require_relative '../app/init'

restaurant_entity = Restaurant::RestaurantMapper.new(App.config.GMAP_TOKEN).restaurant_obj_lists[0]

# Add restaurant to database
restaurant_repo_entity = Repository::For.entity(restaurant_entity).create(restaurant_entity)
