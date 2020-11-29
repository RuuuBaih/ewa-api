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
        # Get cookie viewer's previously seen projects
        session[:watching] ||= []

        restaurants = Repository::For.klass(Entity::Restaurant).all

        if session[:watching].count > 5
          session[:watching] = session[:watching][0..4]
        end

        unless session[:watching].nil?
          history = session[:watching].map do |history_id|
            Repository::For.klass(Entity::Restaurant).find_by_rest_id(history_id)
          end
        else
          flash.now[:notice] = '尋找城市，開啟饗宴！ Search a place to get started!'
        end

        # session[:pick_9rests] ||= []
        view 'home_test', locals: { restaurants: restaurants, history: history }
      end

      routing.on 'restaurant' do
        routing.is do
          # POST /restaurant
          routing.post do
            # parameters call from view
            town = routing.params['town']
            min_money = routing.params['min_money']
            max_money = routing.params['max_money']
            if (min_money.to_i >= max_money.to_i) ||
                  (min_money.to_i < 0) || (max_money.to_i <= 0)
              flash[:error] = '輸入格式錯誤 Wrong number type.'
              response.status = 400
              routing.redirect '/'
            end
            if (max_money.to_i <= 100)
              flash[:error] = '金額過小 Max price is too small.'
              response.status = 400
              routing.redirect '/'
            end
            # select restaurants from the database
            selected_entities = Repository::For.klass(Entity::Restaurant)
                                               .find_by_town_money(town, min_money, max_money)

            # pick 9 restaurants
            rests = Mapper::RestaurantOptions.new(selected_entities)
            pick_9rests = rests.random_9picks
            rests_info = Mapper::RestaurantOptions::GetRestInfo.new(pick_9rests)
            # rests_info = Restaurant::RestaurantOptionsMapper::GetRestInfo.new(pick_9rests)
            pick_ids = rests_info._9_id_infos
            img_links = rests_info.random_thumbs
            pick_names = rests_info._9_name_infos
            session[:pick_9rests] = pick_ids
            if pick_ids.count < 9
              flash[:error] = '資料過少，無法顯示 Not enough data.'
              response.status = 400
              routing.redirect '/'
            end
            # session[:img_num] = img_num
            # pick_one = @rests.pick_one(@pick_9rests, 2)
            view 'restaurant', locals: { pick_9rests: pick_ids, img_links: img_links, pick_names: pick_names }
          end
        end

        routing.on 'pick' do
          # POST /restaurant/pick
          # select one of them
          routing.is do
            routing.post do
              rest_id = routing.params['img_num'].to_i
              search = routing.params['search']
              rest_search = Repository::For.klass(Entity::Restaurant).rest_convert2_id(search).nil? rescue true
              if rest_search == false
                rest_pick_id = Repository::For.klass(Entity::Restaurant).rest_convert2_id(search).id
                routing.redirect "pick/#{rest_pick_id}"
              elsif !rest_id.zero?
                rest_pick_id = rest_id
                routing.redirect "pick/#{rest_pick_id}"
              else
                flash[:error] = '無此餐廳 Restaurant is not found.'
                response.status = 400
                routing.redirect '/'
              end
            end
          end

          routing.on String do |rest_id|
            routing.get do
              rest_detail = Repository::For.klass(Entity::Restaurant).find_by_rest_id(rest_id)
              session[:watching].insert(0, rest_detail.id).uniq!
              view 'res_detail', locals: { rest_detail: rest_detail }
            end
          end
        end
      end
    end
  end
end