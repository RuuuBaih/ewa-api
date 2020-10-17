# frozen_string_literal: false

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/pixnet_lib/pix_keyword_api'

KEYWORDS_EN_TEST = 'Gucci'.freeze
KEYWORDS_CN_TEST = '螺絲瑪麗'.freeze
KEYWORDS_ERR_TEST = 'soumyaray'.freeze
KEYWORDS_EN_LIST = ['GUCCI', '巴黎迪士尼', '古董', '精品', '義大利', '歐洲自助', '東京',
                    '下午茶', 'VOGUE', 'Snoopy', 'sur', 'outlet', '巴黎', '咖啡', '甜點',
                    '日本', 'FacebookSEO', 'Noir Gucci Ceintures', '時尚潮流-時尚單品', 'Facebook讚好'].freeze
KEYWORDS_CN_LIST = ['螺絲瑪麗', '義大利麵', '螺絲瑪麗意麵坊', 'Rose Mary', 'Rose Mary螺絲瑪麗意麵坊', '中山捷運'].freeze

describe 'Tests PIXNET API library' do
  describe 'keywords' do
    it 'HAPPY: should have correct keywords results ' do
      _(JustRuIt::PixKeywordApi.new(KEYWORDS_EN_TEST).keyword_lists).must_equal KEYWORDS_EN_LIST
      _(JustRuIt::PixKeywordApi.new(KEYWORDS_CN_TEST).keyword_lists).must_equal KEYWORDS_CN_LIST
    end

    it 'SAD: should raise exception on incorrect project' do
      _(JustRuIt::PixKeywordApi.new(KEYWORDS_ERR_TEST).keyword_lists).must_raise JustRuIt::Errors::NotFound
    end
  end
end
