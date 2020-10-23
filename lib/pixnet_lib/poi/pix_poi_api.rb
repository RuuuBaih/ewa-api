# frozen_string_literal: true

require 'http'
require_relative 'poilists'

# Food & Restaurant reviews and articles integrated application
module JustRuIt
  # Library for Pixnet poi list API
  class PixPoiApi
    POI_API_PATH = 'https://emma.pixnet.cc/poi?page=1&per_page='

    def initialize(per_page)
      @per_page = per_page
    end

    def poi_lists
      poi_req_url = pix_poi_api_path(@per_page)
      # below puts is for testing
      # puts poi_req_url
      related_poi = call_pix_url(poi_req_url).parse
      PoiLists.new(related_poi).poi_lists
    end

    private

    def pix_poi_api_path(path)
      "#{API_PROJECT_ROOT}#{path}"
    end

    def call_pix_url(url)
      result = HTTP.get(url)
      # below puts is for testing
      # puts result
      successful?(result) ? result : raise(HTTP_ERROR[result.code])
    end
    class Request
      def initialize(resource_root, keyword)
        @resource_root = resource_root
        @keyword = keyword
      end

      def keyword_http
        get(@resource_root + @keyword)
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
