# frozen_string_literal: true

require "json"
require "roda"
require "slim"
require "slim/include"
# require_relative 'helpers.rb'

module Ewa
  # Web App
  class App < Roda
    # include RouteHelpers
    plugin :render, engine: "slim", views: "app/presentation/views_html"
    plugin :assets, css: "style.css", path: "app/presentation/assets"
    plugin :halt
    plugin :flash
    plugin :all_verbs

    use Rack::MethodOverride

    route do |routing|
      response["Content-Type"] = "application/json"

      # GET /
      routing.root do
        message = "Ewa API v1 at /api/v1/ in #{App.environment} mode"
        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on "api/v1" do
        routing.on "restaurants" do
          # GET /restaurant
          routing.get do
            result = Service::ShowAllRests.new.call

            if result.failure?
              failed = Representer::HttpResponse.new(result.failure)
              routing.halt failed.http_status_code, failed.to_json
            end
            http_response = Representer::HttpResponse.new(result.value!)
            # raise "#{http_response.inspect}, #{http_response.class}, #{http_response.represented.status}"
            response.status = http_response.http_status_code
            raise "#{http_response.inspect}, #{http_response.class}, #{http_response.represented.status}"
            # change to our own representer "restaurant_all"
            Representer::AllRestaurants.new(
              result.value!.message
            ).to_json
          end

          # GET /restaurant?town=
          routing.is do
            routing.get do
              # request base64 encoder
              # select restaurants from the database
              select_rest = Request::SelectRests.new(routing.params)
              result = Service::SelectRests.new.call(town: select_rest['town'], min_money: select_rest['min_money'], max_money: select_rest['max_money'])

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end
              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code

              # change to our own representer "restaurant_all"
              Representer::FilteredRestaurants.new(
                result.value!.message
              ).to_json
            end
          end

          routing.on "picks" do
            # GET /restaurant/picks/#{id}
            # select one of 9 pick or search restaurant by name
            routing.is on String do |rest_id|
              routing.get do
                # select_id = Request::SelectbyID.new(routing.params)
                result = Service::FindPickRest.new.call(rest_id)
                raise "#{}"
                if result.failure?
                  failed = Representer::HttpResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end
                http_response = Representer::HttpResponse.new(result.value!)
                response.status = http_response.http_status_code

                # change to our own representer "restaurant id"
                Representer::FilteredRestaurants.new(
                  result.value!.message
                ).to_json
              end
            end
              # GET /restaurant/picks?name={restaurant name}
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
              Representer::FilteredRestaurants.new(
                result.value!.message
              ).to_json
            end
          end

          routing.on "random" do
            # POST /restaurant/pick/random?num={random number}&
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