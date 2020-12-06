# frozen_string_literal: false

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'
# require 'database_cleaner'

describe 'Integration Tests of Gmap API and Database' do
  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_restaurant
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store restaurant' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save restaurant to database' do
      restaurant = Ewa::Restaurant::RestaurantMapper
                   .new(GMAP_TOKEN)
                   .restaurant_obj_lists[0]
      puts restaurant.inspect

      rebuilt = Ewa::Repository::For.entity(restaurant).create(restaurant)

      _(rebuilt.restaurant_id).must_equal(restaurant.restaurant_id)
      _(rebuilt.article_id).must_equal(restaurant.article_id)
      _(rebuilt.name).must_equal(restaurant.name)
      _(rebuilt.town).must_equal(restaurant.town)
      _(rebuilt.money).must_equal(restaurant.money)
      _(rebuilt.city).must_equal(restaurant.city)
      _(rebuilt.telephone).must_equal(restaurant.telephone)
      _(rebuilt.cover_img).must_equal(restaurant.cover_img)
      _(rebuilt.tags).must_equal(restaurant.tags)
      _(rebuilt.pixnet_rating).must_equal(restaurant.pixnet_rating)
      _(rebuilt.google_rating).must_equal(restaurant.google_rating)
      _(rebuilt.open_hours).must_equal(restaurant.open_hours)

      #       restaurant.reviews.each do |review|
      #               found = rebuilt.reviews.find do |potential|
      #                         potential.review_id == review.review_id
      #                                 end
      #                                         _(found.author_name).must_equal member.author_name
      #                                                 # not checking email as it is not always provided
      #                                                       end
    end
  end
end
