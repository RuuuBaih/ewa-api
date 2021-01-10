# frozen_string_literal: false

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'

describe 'Integration Tests of Gmap API and Database' do
  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_restaurant

    config = YAML.safe_load(File.read('config/secrets.yml'))
    token = config['development']['GMAP_TOKEN']
    cx = config['development']['CX']

    # Restaurant
    @restaurants = Ewa::Restaurant::RestaurantMapper
      .new(token, cx, "中山區", 2).restaurant_obj_lists
    @restaurant = @restaurants[1]
    @rebuilt = Ewa::Repository::For.entity(@restaurant).create(@restaurant)


    # Restaurant Detail
    @rebuilt_details = Ewa::Repository::RestaurantDetails.find_by_rest_id(@rebuilt.id)

    @rest_detail_entity = Ewa::Restaurant::RestaurantDetailMapper
      .new(@rebuilt, token).gmap_place_details

    #binding.irb
    if @rebuilt_details.google_rating.nil?
      #if nil, first time
      @rest_detail = Ewa::Repository::RestaurantDetails.update(@rest_detail_entity, true)
    else
      #if not nil, not first time
      @rest_detail = Ewa::Repository::RestaurantDetails.update(@rest_detail_entity, false)
    end
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store restaurant' do
    it 'HAPPY: should be able to save restaurant to database' do
      _(@rebuilt.name).must_equal(@restaurant.name)
      _(@rebuilt.town).must_equal(@restaurant.town)
      _(@rebuilt.money).must_equal(@restaurant.money)
      _(@rebuilt.city).must_equal(@restaurant.city)
      _(@rebuilt.telephone).must_equal(@restaurant.telephone)
      _(@rebuilt.cover_img).must_equal(@restaurant.cover_img)
      _(@rebuilt.tags).must_equal(@restaurant.tags)
      _(@rebuilt.pixnet_rating).must_equal(@restaurant.pixnet_rating)
    end
  end

  describe 'Retrieve and store restaurant details (google)' do
    it 'Should be able to save restaurant details (google) to database' do
      _(@rebuilt_details.reviews).must_equal(@rest_detail.reviews)
      _(@rebuilt_details.pictures).must_equal(@rest_detail.pictures)
      _(@rebuilt_details.article).must_equal(@rest_detail.article)
    end
  end
end
