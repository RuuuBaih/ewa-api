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
        view 'home_test', locals: { restaurants: restaurants }
      end

      routing.on 'restaurant' do
        routing.is do
          # GET /restaurant
          routing.post do
            # Get restaurant information from pixnet & gmap api
                         #restaurant_entities = Restaurant::RestaurantMapper.new(App.config.GMAP_TOKEN).restaurant_obj_lists
            
                         #restaurant_repo_entities = restaurant_entities.map do |restaurant_entity|
                           #Repository::For.entity(restaurant_entity).create(restaurant_entity)
                         #end
            # parameters call from view
            town = routing.params['town']
            min_money = routing.params['min_money']
            max_money = routing.params['max_money']
            img_num = routing.params['img_num']

            # select restaurants from the database
            selected_entities = Repository::For.klass(Entity::Restaurant)
                                               .find_by_town_money(town, min_money, max_money)

            # pick 9 restaurants
            rests = Mapper::RestaurantOptions.new(selected_entities)
            pick_9rests = rests.random_9picks
            # select one of them
            #pick_one = rests.pick_one(pick_9rests, img_num)

            view 'restaurant', locals: { pick_9rests: pick_9rests, rests: rests}
            
          end
        end

        
        
      end

      routing.on 'res_detail' do
        routing.is do
          # GET /restaurantd
          routing.post do
            # parameters call from view
            pick_9rests = routing.params['img_num'][1]
            rests = routing.params['img_num'][2]
            img_num = routing.params['img_num'][0]
            # select one of them
            pick_one = rests.pick_one(pick_9rests, img_num)

            view 'res_detail', locals: {  img_num: img_num, pick_one: pick_one}
            
          end
        end
      end

    end
  end
end

