# frozen_string_literal: false

require 'minitest/autorun'
require 'minitest/rg'
require_relative '../lib/pixnet_lib/pix_keyword_api'
require_relative '../lib/pixnet_lib/pix_poi_api'

KEYWORDS_EN_TEST = 'Gucci'.freeze
KEYWORDS_CN_TEST = '螺絲瑪麗'.freeze
KEYWORDS_ERR_TEST = 'soumyaray'.freeze
KEYWORDS_CN_LIST = ['螺絲瑪麗', '義大利麵', '螺絲瑪麗意麵坊', 'Rose Mary', 'Rose Mary螺絲瑪麗意麵坊', '中山捷運'].freeze
POI_LENGTH = 10

describe 'Tests PIXNET API library' do
  describe 'keywords' do
    it 'HAPPY: should have correct English keywords results ' do
      _(JustRuIt::PixKeywordApi.new(KEYWORDS_EN_TEST).keyword_lists.length).must_equal 20
    end

    it 'HAPPY: should have correct Chinese keywords results ' do
      _(JustRuIt::PixKeywordApi.new(KEYWORDS_CN_TEST).keyword_lists).must_equal KEYWORDS_CN_LIST
    end

    it 'SAD: the keyword is not found' do
      _(JustRuIt::PixKeywordApi.new(KEYWORDS_ERR_TEST).keyword_lists).must_equal []
    end
  end

  describe 'poi' do
    it 'HAPPY: should have same length of ' do
      _(JustRuIt::PixPoiApi.new(10).poi_lists.values[4].length).must_equal POI_LENGTH
    end
  end
end
