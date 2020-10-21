# frozen_string_literal: true

require 'http'
require_relative 'keywordlists'

# Food & Restaurant reviews and articles integrated application
module JustRuIt
  # An api which can get a list of keywords from one keyword
  class PixKeywordApi
    API_PROJECT_ROOT = 'https://emma.pixnet.cc/explorer/keywords?format=json&key='

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

    def initialize(keyword)
      @keyword = keyword
    end

    def keyword_lists
      keyword_req_url = pix_keyword_api_path(@keyword)
      # below puts is for testing
      # puts keyword_req_url
      related_keywords = call_pix_url(keyword_req_url).parse
      KeywordLists.new(related_keywords).keyword_lists
    end

    private

    def pix_keyword_api_path(path)
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
