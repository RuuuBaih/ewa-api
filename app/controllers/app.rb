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
            town = routing.params['town']
            min_money = routing.params['min_money']
            max_money = routing.params['max_money']

            # select restaurants from the database
            selected_entities = Repository::For.klass(Entity::Restaurant)
                                               .find_by_town_money(town, min_money, max_money)

            # pick 9 restaurants
            @rests = Mapper::RestaurantOptions.new(selected_entities)
            @pick_9rests = @rests.random_9picks

            view 'restaurant', locals: { pick_9rests: @pick_9rests }
          end
        end

        routing.on 'test_detail' do
            # GET /restaurant/test_detail
            # select one of them
          routing.is do
            routing.post do
              # num = routing.params['num']
              pick_one = @rests.pick_one(@pick_9rests, 2)

              view 'test_detail', locals: { pick_one: pick_one }
            end
          end
        end
      end
    end
  end
end
