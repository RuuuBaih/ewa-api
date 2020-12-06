# frozen_string_literal: true

require 'json'
require 'roda'
require 'slim'
require 'slim/include'
# require_relative 'helpers.rb'

module Ewa
  # Web App
  class App < Roda
    # include RouteHelpers
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :assets, css: 'style.css', path: 'app/presentation/assets'
    plugin :halt
    plugin :flash
    plugin :all_verbs

    use Rack::MethodOverride

    route do |routing|
      response['Content-Type'] = 'application/json'

      # GET /
      routing.root do
        # message = "CodePraise API v1 at /api/v1/ in #{App.environment} mode"
        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'api/v1' do
        routing.on 'restaurant' do
          # GET /restaurant
          routing.get do
            result = Service::ShowAllRests.new.call
        
            if result.failure?
              failed = Representer::HttpResponse.new(result.failure)
              routing.halt failed.http_status_code, failed.to_json
            end
            http_response = Representer::HttpResponse.new(result.value!)
            response.status = http_response.http_status_code
            
            # change to our own representer "restaurant_all"
            Representer::ProjectFolderContributions.new(
              result.value!.message
            ).to_json
          end

          # POST /restaurant
          routing.is do
            # request call filter options
            town = routing.params['town']
            min_money = routing.params['min_money']
            max_money = routing.params['max_money']   
            # request base64 encoder      
            # select restaurants from the database
            select_rest = Request::SelectRests.new(routing.params)
            result = Service::SelectRests.new.call(town: town, min_money: min_money, max_money: max_money)

            if result.failure?
              failed = Representer::HttpResponse.new(result.failure)
              routing.halt failed.http_status_code, failed.to_json
            end
            http_response = Representer::HttpResponse.new(result.value!)
            response.status = http_response.http_status_code
            
            # change to our own representer "restaurant_all"
            Representer::ProjectFolderContributions.new(
              result.value!.message
            ).to_json
          end

        routing.on 'pick' do
          # GET /restaurant/pick?id={restaurant id}
          # select one of 9 pick or search restaurant by name
          routing.is do
            routing.get do
              # rest_id = routing.params['img_num'].to_i
              select_id = Request::SelectbyID.new(routing.params)
              result = Service::FindPickRest.new.call(rest_id: select_id)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end
              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              
              # change to our own representer "restaurant id"
              Representer::ProjectFolderContributions.new(
                result.value!.message
              ).to_json
            end

            # GET /restaurant/pick?name={restaurant name}
            routing.get do
              # search = routing.params['search']
              select_name = Request::SelectbyName.new(routing.params)
              result = Service::SearchRestName.new.call(search: select_name)
              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end
              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              
              # change to our own representer "restaurant name"
              Representer::ProjectFolderContributions.new(
                result.value!.message
              ).to_json
            end
          end

          routing.on String do |rest_id|
            routing.get do

              rest_find = Service::FindPickRest.new.call(rest_id)
              if rest_find.failure?
                flash[:error] = rest_find.failure
                routing.redirect '/'
              else
                rest_detail = rest_find.value!
              end
              session[:watching].insert(0, rest_detail.id).uniq!
              viewable_resdetail = Views::Resdetail.new(rest_detail)
              view 'res_detail', locals: { rest_detail: viewable_resdetail }
            end
          end
        end

        routing.on 'random' do
          # POST /restaurant/pick/random?num={random number}
          # select one of 9 pick or search restaurant by name
          routing.get do
            # test_ids = [1, 12, 22, 33, 32, 27, 45]
            # test_num = 5
            random_num = Request::SelectbyName.new(routing.params)
            result = Service::SelectRandomRestList.new.call(test_ids, test_num: random_num)
            if result.failure?
              failed = Representer::HttpResponse.new(result.failure)
              routing.halt failed.http_status_code, failed.to_json
            end
            http_response = Representer::HttpResponse.new(result.value!)
            response.status = http_response.http_status_code
            
            # change to our own representer "restaurant name"
            Representer::ProjectFolderContributions.new(
              result.value!.message
            ).to_json
          end
        end
      end
    end
  end
end
end