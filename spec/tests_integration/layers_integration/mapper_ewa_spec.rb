# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'

# testing poi
POI_LENGTH = 9
# testing review
REVIEW_LENGTH = 5
# testing cover pictures
COVER_PICTURES_LENGTH = 10

REST_NAME = 'RoseMary'
ARTICLE_HASH = { 'keyword' => 'RoseMary', 'link' => 'https://atroposbox.pixnet.net/blog/post/66733015' }.freeze
ARTICLE_LENGTH = 2
WRONG_REST_NAME = 'wrongbalabilibon'
WRONG_REST_TOTAL_NUM = 0
SAMPLE_TOWN = "中山區"
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
      @restaurant_place_api = Ewa::Gmap::PlaceApi
      @restaurant_poi_api = Ewa::Pixnet::PoiApi
      @restaurant_detail_api = Ewa::Gmap::PlaceDetailsApi
      @restaurant_mapper = Ewa::Restaurant::RestaurantMapper
      @restaurant_entity = Ewa::Entity::Restaurant
      @sample_rest = @restaurant_mapper.new(GMAP_TOKEN, CX, SAMPLE_TOWN).restaurant_obj_lists[0]
    end

    describe 'restaurant poi' do
      @restaurant_mapper = Ewa::Restaurant::RestaurantMapper
      puts @restaurant_mapper.inspect
      pois = @restaurant_mapper::PoiDetails.new(@restaurant_poi_api, SAMPLE_TOWN, 1, false).poi_details
      it 'HAPPY: should have same length of poi' do
        _(pois.length).must_equal POI_LENGTH
      end
      it 'HAPPY: should have category_id = 0' do
        _(pois[0]['category_id']).must_equal 0
      end
    end

    describe 'reviews' do
      reviews = @sample_rest.reviews
      it 'HAPPY: should have same length of review' do
        _(reviews.length).must_equal REVIEW_LENGTH
      end

      it 'BAD: wrong token cause empty array' do
        bad_token = @restaurant_place_api.new('GMAP_TOKEN', '薌筑園').place_id['candidates']
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

  describe 'Tests custom search API library' do
    before do
      @custom_search_api = Ewa::CustomSearch::CustomSearchApi
      @restaurant_mapper = Ewa::Restaurant::RestaurantMapper
    end

    describe 'cover picture length' do
      cover_pictures = @sample_rest.cover_pictures
      it 'HAPPY: should have same length of the cover_pictures length' do
        _(cover_pictures.length).must_equal COVER_PICTURES_LENGTH
      end
    end

    describe 'custom bad keyword' do
      it 'SAD: should have the same result of the not found keyword' do
        _(@custom_search_api.new(TOKEN, WRONG_REST_NAME, CX).search_photo['searchInformation']['totalResults'])
          .must_equal WRONG_REST_TOTAL_NUM
      end
    end
  end
end
