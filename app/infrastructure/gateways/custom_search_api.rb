# frozen_string_literal: true

require 'http'

module Ewa
  module Gmap
    # Client Library for Gmap Web API: PlaceApi, use a place name to search place id
    class CustomSearchApi
      GMAP_API_PATH = 'https://customsearch.googleapis.com/customsearch/v1?fileType=jpg&searchType=image&imgType=photo'

      def initialize(token, rest, cx)
        @gmap_token = token
        @restaurant_name = rest
        @search_engine = cx
      end

      def place_id
        PlaceRequest.new(GMAP_API_PATH, @gmap_token, @restaurant_name, @search_engine).gmap_place_http.parse(:json)
      end

      # Sends out HTTP requests to Gmap
      class PlaceRequest
        def initialize(resource_root, token, rest, cx)
          @resource_root = resource_root
          @token = token
          @restaurant_name = rest
          @search_engine = cx
        end
        
        
        def gmap_place_http
          Gmap::Request.new("#{@resource_root}&q=#{@restaurant_name}&cx=#{@search_engine}&key=#{@token}").get
        end
      end
    end

    # Send requests
    class Request
      def initialize(url)
        @url = url
      end

      def get
        http_response = HTTP.get(@url)

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
