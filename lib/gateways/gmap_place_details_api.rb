# frozen_string_literal: true

require 'http'

module Ewa
  module Gmap
    # Client Library for Gmap Web API
    class PlaceDetailsApi
      GMAP_API_PATH = 'https://maps.googleapis.com/maps/api/place/details/json?'

      # language default is Taiwanese
      def initialize(token, place_id, language = 'zh-TW')
        @gmap_token = token
        @place_id = place_id
        @language = language
      end

      def place_details
        Request.new(GMAP_API_PATH, @gmap_token, @place_id, @language).gmap_place_http.parse
      end

      # Sends out HTTP requests to Gmap
      class Request
        def initialize(resource_root, token, place_id, language)
          @resource_root = resource_root
          @token = token
          @place_id = place_id
          @language = language
        end

        def gmap_place_http
          get("#{@resource_root}place_id=#{@place_id}&language=#{@language}&key=#{@token}")
        end

        def get(url)
          http_response = HTTP.get(url)

          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
        end
      end

      # Decorates HTTP responses from Github with success/error
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
