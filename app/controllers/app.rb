# frozen_string_literal: true
require 'json'
require 'roda'
require 'slim'

module Ewa
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt
    plugin :flash

    route do |routing|
      routing.assets # load CSS

      # POST /
      routing.root do
        restaurants = Repository::For.klass(Entity::Restaurant).all
        session[:pick_9rests] ||= []
        view 'home_test', locals: { restaurants: restaurants }
      end

      routing.on 'restaurant' do
        routing.is do
          # POST /restaurant
          routing.post do
            # Get restaurant information from pixnet & gmap api
=begin            
                         restaurant_entities = Restaurant::RestaurantMapper.new(App.config.GMAP_TOKEN).restaurant_obj_lists
            
                         restaurant_entities.map do |restaurant_entity|
                           Repository::For.entity(restaurant_entity).create(restaurant_entity)
                         end
=end                         
            # parameters call from view
            town = routing.params['town']
            min_money = routing.params['min_money']
            max_money = routing.params['max_money']
            # select restaurants from the database
            selected_entities = Repository::For.klass(Entity::Restaurant)
                                               .find_by_town_money(town, min_money, max_money)

            # pick 9 restaurants
            rests = Mapper::RestaurantOptions.new(selected_entities)
            pick_9rests = rests.random_9picks
            session[:pick_9rests] = pick_9rests
            #session[:img_num] = img_num
            # pick_one = @rests.pick_one(@pick_9rests, 2)
            view 'restaurant', locals: { pick_9rests: pick_9rests }
            # routing.redirect "restaurant/test_detail"
          end
        end
      end

      routing.on 'pick' do
        # POST /restaurant/test_detail
        # select one of them
        routing.is do
          routing.post do
            img_num = routing.params['img_num']
            pick_nine = session[:pick_9rests]
            view 'test_detail', locals: { pick_nine: pick_nine, img_num: img_num }
          end
        end
      end
    end
  end
end

