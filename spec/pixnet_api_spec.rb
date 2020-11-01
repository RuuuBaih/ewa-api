# frozen_string_literal: true

require_relative 'spec_helper'

KEYWORDS_EN_TEST = 'Gucci'
KEYWORDS_CN_TEST = '螺絲瑪麗'
KEYWORDS_ERR_TEST = 'soumyaray'
POI_LENGTH = 1

describe 'Tests Ewa API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<GITHUB_TOKEN>') { GH_TOKEN }
    c.filter_sensitive_data('<GITHUB_TOKEN_ESC>') { CGI.escape(GH_TOKEN) }
  end

  before do
    VCR.insert_cassette PIXNET_CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Tests PIXNET API library' do
=begin
    describe 'keywords' do
      it 'HAPPY: chinese keyword should return a list of keywords' do
        cn_keyword_lists = JustRuIt::PixKeywordApi.new(KEYWORDS_CN_TEST).keyword_lists
        _(0..20).must_include cn_keyword_lists.count
        # _(JustRuIt::PixKeywordApi.new(KEYWORDS_CN_TEST).keyword_lists.class).must_equal Array
      end

      it 'HAPPY: english keyword should return a list of keywords' do
        en_keyword_lists = JustRuIt::PixKeywordApi.new(KEYWORDS_CN_TEST).keyword_lists
        _(0..20).must_include en_keyword_lists.count
        # _(JustRuIt::PixKeywordApi.new(KEYWORDS_EN_TEST).keyword_lists.class).must_equal Array
      end

      it 'SAD: the keyword is not found' do
        err_keyword_lists = JustRuIt::PixKeywordApi.new(KEYWORDS_ERR_TEST).keyword_lists
        _(err_keyword_lists.count).must_equal 0
        # _(JustRuIt::PixKeywordApi.new(KEYWORDS_ERR_TEST).keyword_lists).must_equal []
      end
    end
=end

    describe 'poi' do
      it 'HAPPY: should have same length of poi' do
        poi = Ewa::Restaurant::RestaurantMapper.new(GMAP_TOKEN).poi_details
        _(poi.length).must_equal POI_LENGTH
      end
    end
=begin
    describe 'article' do
      it 'HAPPY: should have same length of poi' do
        _(Ewa::Pixnet::PoiApi.new(1, 10).poi_lists.values[2].values[4].length).must_equal POI_LENGTH
      end
    end
=end

  end

  describe 'Tests Google API library' do
    describe 'Google place api' do
      it 'Happy: should have correct google place attribute' do

      end

      it 'BAD: should raise exception on google place attribute' do
        _(proc do
          Ewa::Restaurant::RestaurantMapper.new(GMAP_TOKEN)
            .gmap_place_details(poi_filtered_hash)
        end).must_raise CodePraise::Github::Api::Response::NotFound
      end

      it 'BAD: should raise exception when unauthorized' do
        _(proc do
          CodePraise::Github::ProjectMapper
            .new('BAD_TOKEN')
            .find(USERNAME, PROJECT_NAME)
        end).must_raise CodePraise::Github::Api::Response::Unauthorized
      end
    end
  end
end
