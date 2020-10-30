# frozen_string_literal: true

require 'http'

# Food & Restaurant reviews and articles integrated application
module Ewa
  module Pixnet
    # Library for Pixnet poi list API
    class PoiApi
      POI_API_PATH = 'https://emma.pixnet.cc/poi?'

      def initialize(page, per_page)
        @page = page
        @per_page = per_page
      end

      def poi_lists
        Request.new(POI_API_PATH, @page, @per_page).poi_http.parse
      end

      # Sends out HTTP requests to POI
      class Request
        def initialize(resource_root, page, per_page)
          @resource_root = resource_root
          @page = page
          @per_page = per_page
        end

        def poi_http
          get("#{@resource_root}page=#{@page}&per_page=#{@per_page}")
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
        # No authority to the http
        Unauthorized = Class.new(StandardError)
        # Can't find the http
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
