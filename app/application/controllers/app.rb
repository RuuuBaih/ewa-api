# frozen_string_literal: true

require 'json'
require 'roda'
require 'slim'
require 'slim/include'
#require_relative 'helpers.rb'

module Ewa
  # Web App
  class App < Roda
    #include RouteHelpers
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

        rest_all = RestaurantActions::Rest.new.RestAll

        if rest_all.failure?
          flash[:error] = rest_all.failure
        else
          restaurants = rest_all.value!
        end

        if session[:watching].count > 5
          session[:watching] = session[:watching][0..4]
        end

        history_id = RestaurantOthers::History_id.new.call(session[:watching])

        if history_id.failure?
          flash[:error] = history_id.failure
        else
          his_id = history_id.value!
          if session[:watching].nil?
            flash.now[:notice] = '尋找城市，開啟饗宴！ Search a place to get started!'
          end
        end

        history_name = RestaurantOthers::History_name.new.call(session[:watching])

        if history_name.failure?
          flash[:error] = history_name.failure
        else
          his_name = history_name.value!
        end

        view 'home_test', locals: { restaurants: restaurants, history_id: his_id, history_name: his_name  }
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
              routing.redirect '/'
            end
            if (max_money.to_i <= 100)
              flash[:error] = '金額過小 Max price is too small.'
              routing.redirect '/'
            end
            # select restaurants from the database
            selected_rest = RestaurantActions::SelectRest.new.call(town, min_money, max_money)
            if selected_rest.failure?
              flash[:error] = selected_rest.failure
            else
              selected_entities = selected_rest.value!
            end

            # pick 9 restaurants
            rests = RestaurantActions::Pick_9.new.call(selected_entities)
            if rests.failure?
              flash[:error] = rests.failure
            else
              rests_info = rests.value!
            end
            pick_ids = rests_info._9_id_infos
            if pick_ids.count < 9
              flash[:error] = '資料過少，無法顯示 Not enough data.'
              response.status = 400
              routing.redirect '/'
            end
            img_links = rests_info.random_thumbs
            pick_names = rests_info._9_name_infos
            session[:pick_9rests] = pick_ids
            view 'restaurant', locals: { pick_9rests: pick_ids, img_links: img_links, pick_names: pick_names }
          end
        end

        routing.on 'pick' do
          # POST /restaurant/pick
          # select one of 9 pick or search restaurant by name
          routing.is do
            routing.post do
              rest_id = routing.params['img_num'].to_i
              search = routing.params['search']
              #history = routing.params['history']
              search_result = RestaurantOthers::SearchRest.new.call(search)
              if !rest_id.zero?
                rest_pick_id = rest_id
                routing.redirect "pick/#{rest_pick_id}"
                # viewable_projects = []
              elsif search_result.failure?
                flash[:error] = search_result.failure
                routing.redirect '/'
              else
                rest_pick_id = search_result.value!
                routing.redirect "pick/#{rest_pick_id}"
              end
            end
          end

          routing.on String do |rest_id|
            routing.get do
              rest_find = RestaurantActions::FindRest.new.call(rest_id)
              if rest_find.failure?
                flash[:error] = rest_find.failure
              else
                rest_detail = rest_find.value!
              end
              session[:watching].insert(0, rest_detail.id).uniq!
              view 'res_detail', locals: { rest_detail: rest_detail }
            end
          end
        end
      end
    end
  end
end