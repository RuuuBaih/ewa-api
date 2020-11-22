# frozen_string_literal: true
require 'json'
require 'roda'
require 'slim'
require 'slim/include'

module Ewa
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :assets, css: 'style.css', path: 'app/presentation/assets'
    plugin :halt
    plugin :flash
    plugin :all_verbs

    use Rack::MethodOverride

    route do |routing|
      routing.assets # load CSS

      # POST /
      routing.root do
        restaurants = Repository::For.klass(Entity::Restaurant).all

        if restaurants.none?
          flash.now[:notice] = '尋找城市，開啟饗宴！ Search a place to get started'
        end
        # session[:pick_9rests] ||= []
        view 'home_test', locals: { restaurants: restaurants }
      end

      routing.on 'restaurant' do
        routing.is do
          # POST /restaurant
          routing.post do
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
            view 'restaurant_test', locals: { pick_9rests: pick_9rests }
            # routing.redirect "restaurant/test_detail"
          end
        end

        routing.on 'pick' do
          # POST /restaurant/pick
          # select one of them
          routing.is do
            routing.post do
              rest_id = routing.params['img_num'].to_i
              pick_9rests = session[:pick_9rests]
              routing.redirect "pick/#{rest_id}"
            end
          end

          routing.on String do |rest_id|
            routing.get do
              # path = request.remaining_path
              rest_detail = Repository::For.klass(Entity::Restaurant).find_by_rest_id(rest_id)
              pick_9rests = session[:pick_9rests]
              view 'test_detail', locals: { rest_detail: rest_detail, pick_9rests: pick_9rests }
            end
          end
        end
      end
    end
  end
end

