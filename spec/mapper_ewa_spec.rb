# frozen_string_literal: true

require_relative 'spec_helper'

REST_NAME = '螺絲瑪莉 Rose Mary'
ARTICLE_HASH = { 'keyword' => 'RoseMary', 'link' => 'https://atroposbox.pixnet.net/blog/post/66733015' }.freeze
ARTICLE_LENGTH = 2
WRONG_REST_NAME = 'soumyaray'
WRONG_REST_TOTAL_NUM = 0
# testing page
TEST_PAGE = 1
# testing records will response by per page
TEST_PER_PAGE = 2
REVIEW_LENGTH = 5

describe 'Tests Pix API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<GMAP_TOKEN>') { GMAP_TOKEN }
    c.filter_sensitive_data('<GMAP_TOKEN_ESC>') { CGI.escape(GMAP_TOKEN) }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Tests PIXNET API library' do
    before do
      @article_api = Ewa::Pixnet::ArticleApi
      @article_mapper = Ewa::Restaurant::ArticleMapper
      @article_entity = Ewa::Entity::Article
    end

    describe 'poi' do
      it 'HAPPY: should have same length of poi' do
        poi = Ewa::Restaurant::RestaurantMapper.new(GMAP_TOKEN).poi_details
        _(poi.length).must_equal POI_LENGTH
      end
    end
    
    describe 'article result hash' do
      it 'HAPPY: should have same length of the newest article hash' do
        _(@article_mapper.new(REST_NAME).the_newest_article.length).must_equal ARTICLE_LENGTH
      end
    end

    describe 'article result entity' do
      it 'HAPPY: should have same length of the newest article hash' do
        _(@article_mapper::BuildArticleEntity.new(ARTICLE_HASH).build_entity).must_be_kind_of @article_entity
      end
    end

    describe 'article bad keyword' do
      it 'SAD: should have the same result of the not found keyword' do
        _(@article_api.new(TEST_PAGE, TEST_PER_PAGE, WRONG_REST_NAME).article_lists['total'])
          .must_equal WRONG_REST_TOTAL_NUM
      end
    end
  end
end
