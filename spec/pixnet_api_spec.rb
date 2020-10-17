# frozen_string_literal: false

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/pixnet_lib/pix_keyword_api'

KEYWORDS_EN_TEST = 'Gucci'.freeze
KEYWORDS_CN_TEST = '螺絲瑪麗'.freeze
KEYWORDS_ERR_TEST = 'soumyaray'.freeze
KEYWORDS_EN_LIST = ['gucci', '古馳', 'florence', 'GUCCI', '義大利名牌', '佛羅倫斯', '羅馬機場',
                    'italy', '精品', '義大利', 'Firenze', '百搭款', 'bag', 'outlet', 'survetement gucci', 'the mall',
                    '法國必買', 'Global Blue', 'gucci cafe', 'survetement adidas'].freeze
KEYWORDS_CN_LIST = ['螺絲瑪麗', '義大利麵', '螺絲瑪麗意麵坊', 'Rose Mary', 'Rose Mary螺絲瑪麗意麵坊', '中山捷運'].freeze

describe 'Tests PIXNET API library' do
  describe 'keywords' do
    it 'HAPPY: should have correct English keywords results ' do
      _(JustRuIt::PixKeywordApi.new(KEYWORDS_EN_TEST).keyword_lists).must_equal KEYWORDS_EN_LIST
    end

    it 'HAPPY: should have correct Chinese keywords results ' do
      _(JustRuIt::PixKeywordApi.new(KEYWORDS_CN_TEST).keyword_lists).must_equal KEYWORDS_CN_LIST
    end

    it 'SAD: should raise exception on incorrect project' do
      _(JustRuIt::PixKeywordApi.new(KEYWORDS_ERR_TEST).keyword_lists).must_equal []
    end
  end
end
