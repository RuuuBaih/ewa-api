# frozen_string_literal: true

require 'http'

# Food & Restaurant reviews and articles integrated application
module Ewa
  module Pixnet
    # An api which can get a list of keywords from one keyword
    class PixKeywordApi
      KEYWORD_API_PATH = 'https://emma.pixnet.cc/explorer/keywords?format=json&key='

      def initialize(keyword)
        @new_keyword = keyword
      end

      def keyword_lists
        keyword_response = Request.new(KEYWORD_API_PATH, @new_keyword).keyword_http.parse
        # below puts is for testing
        # puts keyword_response
        KeywordLists.new(keyword_response).keyword_lists
      end

      # Sends out HTTP requests to PIXNET
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
