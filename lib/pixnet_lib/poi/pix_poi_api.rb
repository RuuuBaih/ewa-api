# frozen_string_literal: true

require 'http'
require_relative 'poilists'

# Food & Restaurant reviews and articles integrated application
module JustRuIt
  # Library for Pixnet poi list API
  class PixPoiApi
    POI_API_PATH = 'https://emma.pixnet.cc/poi?'

    def initialize(page, per_page, tags, city, town, min_money, max_money)
      @page = page
      @per_page = per_page
      @tags = tags
      @city = city
      @town = town
      @min_money = min_money
      @max_money = max_money
    end

    def poi_lists
      poi_lists_response = Request.new(POI_API_PATH, @page, @per_page, @tags, @city, @town, @min_money, @max_money)
                                  .poi_http.parse
      puts poi_lists_response
      poi_lists_file = PoiLists.new(poi_lists_response).poi_lists
      Yamlfile.new(poi_lists_file).save_as_yaml_file
    end

    # convert poi results to yaml file
    class Yamlfile
      def initialize(poi_file)
        @poi_file = poi_file
      end

      def save_as_yaml_file
        File.open('../../../spec/fixtures/pixnet_data/poi_lists/poi.yml', 'w') do |file|
          file.write(@poi_file.to_yaml)
        end
      end
    end

    # Sends out HTTP requests to POI
    class Request
      def initialize(resource_root, page, per_page, tags, city, town, min_money, max_money)
        @resource_root = resource_root
        @page = page
        @per_page = per_page
        @tags = tags
        @city = city
        @town = town
        @min_money = min_money
        @max_money = max_money
      end

      def poi_hash
        {
          'page': @page,
          'per_page': @per_page,
          'tags': @tags,
          'city': @city,
          'town': @town,
          'min_money': @min_money,
          'max_money': @max_money
        }
      end

      def input_empty?(input_name, input)
        input.to_s.empty? ? nil : "#{input_name}=#{input}"
      end

      def collect_input
        input_new = []

        poi_hash.map do |key, value|
          test_not_empty = input_empty?(key, value)
          input_new << test_not_empty unless test_not_empty == nil
        end
      end

      def poi_http
        get(@resource_root + collect_input.join('&'))
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
