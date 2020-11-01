# frozen_string_literal: true

require 'http'

module Ewa
  module Gmap
    # Client Library for Gmap Web API
    class PlaceApi
      GMAP_API_PATH = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?'

      def initialize(token, place)
        @gmap_token = token
        @new_place = place
      end

      def place_id
        Request.new(GMAP_API_PATH, @gmap_token, @new_place).gmap_place_http.parse(:json)
      end

      # Sends out HTTP requests to Gmap
      class Request
        def initialize(resource_root, token, place)
          @resource_root = resource_root
          @token = token
          @new_place = place
        end

        def gmap_place_http
          get("#{@resource_root}input=#{@new_place}&inputtype=textquery&key=#{@token}")
        end

        def get(url)
          http_response = HTTP.get(url)

          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
        end
      end

      # Decorates HTTP responses from GMap with success/error
      class Response < SimpleDelegator
        Unauthorized = Class.new(StandardError)
        NotFound = Class.new(StandardError)

        HTTP_ERROR = {
          401 => Unauthorized,
          404 => NotFound
        }.freeze

        def successful?
          HTTP_ERROR.keys.include?(code) ? false : true
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end
