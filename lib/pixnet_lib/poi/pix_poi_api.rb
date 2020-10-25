# frozen_string_literal: true

require 'http'
require_relative 'poilists'

# Food & Restaurant reviews and articles integrated application
module JustRuIt
  # Library for Pixnet poi list API
  class PixPoiApi
    API_PROJECT_ROOT = 'https://emma.pixnet.cc/poi?page=1&per_page='

    module Errors
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end
    end

    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def successful?(result)
      HTTP_ERROR.keys.include?(result.code) ? false : true
    end

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
  end
end
