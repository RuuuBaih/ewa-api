# frozen_string_literal: true

require 'json'
require 'roda'

module Ewa
  # Web App
  class App < Roda
    # include RouteHelpers
    plugin :halt
    plugin :flash
    plugin :all_verbs
    plugin :caching

    use Rack::MethodOverride

    route do |routing|
      response['Content-Type'] = 'application/json'

      # GET /
      routing.root do
        message = "Ewa API v1 at /api/v1/ in #{App.environment} mode"
        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'api/v1' do
        routing.on 'restaurants' do
          # GET /restaurants
          routing.is do
            routing.get do
              response.cache_control public: true, max_age: 3600
              params = routing.params
              # GET /restaurants?town={town}&min_money={min_mon}&max_money={max_mon}
              select_rest = Request::SelectRests.new(params)
              if params.key?('town')
                result = Service::SelectRests.new.call(select_rest)
              else
                result = Service::ShowAllRests.new.call(select_rest)
              end

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end
              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code

              # change to our own representer "restaurants"
              Representer::Restaurants.new(
                result.value!.message
              ).to_json
            end
          end

          routing.on 'picks' do
            # GET /restaurants/picks/#{id}
            # select one of 9 pick
            routing.on String do |rest_id|
              routing.get do
                response.cache_control public: true, max_age: 3600
                result = Service::FindPickRest.new.call(rest_id)
                if result.failure?
                  failed = Representer::HttpResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                http_response = Representer::HttpResponse.new(result.value!)
                response.status = http_response.http_status_code

                # change to our own representer "pick restaurant"
                Representer::PickRestaurant.new(
                  result.value!.message
                ).to_json
              end
            end
          end

          routing.on 'searches' do
            # GET /restaurants/searches?name={restaurant name}
            # search restaurants by name
            routing.get do
              response.cache_control public: true, max_age: 3600
              select_name = Request::SelectbyName.new(routing.params)
              result = Service::SearchRestName.new.call(select_name)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end
              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code

              # change to our own representer "searched restaurants"
              Representer::SearchedRestaurants.new(
                result.value!.message
              ).to_json
            end
          end
        end
      end
    end
  end
end
