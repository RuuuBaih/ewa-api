# frozen_string_literal: true

require 'roda'
require 'slim'

module Ewa
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt

    route do |routing|
      routing.assets # load CSS

      # GET /
      routing.root do
        restaurants = Repository::For.klass(Entity::Restaurant).all
        view 'home', locals: { restaurants: restaurants }
      end

      #       routing.on 'restaurant' do
      #         routing.is do
      #           # POST /restaurant
      #           routing.post do
      #             restaurants = Repository::For.klass(Entity::Restaurant).all
      #             view 'restaurant', locals: { restaurants: restaurants }
      #           end
      #         end
      #       end

      routing.on 'restaurant' do
        routing.is do
          # GET /restaurant
          routing.post do
            # Get restaurant information from pixnet & gmap api

            restaurant_entities = Restaurant::RestaurantMapper.new(App.config.GMAP_TOKEN).restaurant_obj_lists

            restaurant_repo_entities = restaurant_entities.map do |restaurant_entity|
              Repository::For.entity(restaurant_entity).create(restaurant_entity)
            end

            city = '新北市'
            town = '三峽區'
            min_money = 10
            max_money = 1000
            new_restaurant_entities = Repository::For.klass(Entity::Restaurant)
              .find_by_town_money(city, town, min_money, max_money)
            pick_rests = Mapper::RestaurantOptions.new(new_restaurant_entities)._9picks
            # Add restaurant to database
            # view 'restaurant', locals: { restaurants: restaurant_repo_entities.inspect }

            view 'restaurant', locals: { restaurants: pick_rests }
          end
        end
      end
    end
  end
end
