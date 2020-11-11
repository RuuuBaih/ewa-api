# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'

# testing poi
POI_LENGTH = 2
# testing review
REVIEW_LENGTH = 5

REST_NAME = '螺絲瑪莉 Rose Mary'
ARTICLE_HASH = { 'keyword' => 'RoseMary', 'link' => 'https://atroposbox.pixnet.net/blog/post/66733015' }.freeze
ARTICLE_LENGTH = 2
WRONG_REST_NAME = 'soumyaray'
WRONG_REST_TOTAL_NUM = 0
# testing page
TEST_PAGE = 1
# testing records will response by per page
TEST_PER_PAGE = 2

describe 'Tests Ewa API library' do
  before do
    VcrHelper.configure_vcr_for_restaurant
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Tests restaurant API library' do
    before do
      @restaurant_api = Ewa::Gmap::PlaceApi
      @restaurant_detail_api = Ewa::Gmap::PlaceDetailsApi
      @restaurant_mapper = Ewa::Restaurant::RestaurantMapper
      @restaurant_entity = Ewa::Entity::Restaurant
    end

    describe 'restaurant' do
      it 'HAPPY: should have same length of poi' do
        poi = @restaurant_mapper.new(GMAP_TOKEN).poi_details
        _(poi.length).must_equal POI_LENGTH
      end
    end

    describe 'review' do
      it 'HAPPY: should have same length of review' do
        review = @restaurant_mapper.new(GMAP_TOKEN).restaurant_obj_lists[0][:reviews]
        _(review.length).must_equal REVIEW_LENGTH
      end

      it 'BAD: wrong token cause empty array' do
        bad_token = @restaurant_api.new('GMAP_TOKEN', '螺絲瑪莉').place_id['candidates']
        _(bad_token.empty?).must_equal true
      end
    end
  end

  describe 'Tests article API library' do
    before do
      @article_api = Ewa::Pixnet::ArticleApi
      @article_mapper = Ewa::Restaurant::ArticleMapper
      @article_entity = Ewa::Entity::Article
    end

    describe 'article result hash' do
      it 'HAPPY: should have same length of the newest article hash' do
        _(@article_mapper.new(REST_NAME).the_newest_article.length).must_equal ARTICLE_LENGTH
      end
    end

    describe 'article result entity' do
      it 'HAPPY: should have same entity' do
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
