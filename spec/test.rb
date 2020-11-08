# frozen_string_literal: true

require_relative 'spec_helper'
REST_NAME = '螺絲瑪莉 Rose Mary'
=begin
@article_mapper = Ewa::Restaurant::ArticleMapper

puts 'newest_article'
puts @article_mapper.new(REST_NAME).the_newest_article
=end
@restaurant_mapper = Ewa::Restaurant::RestaurantMapper

#puts 'poi_details'
poi = @restaurant_mapper.new('GMAP_TOKEN').poi_details
puts 'restaurant_list'
# @restaurant_mapper.new('GMAP_TOKEN').restaurant_obj_lists[0][:reviews]
#puts @restaurant_mapper.new('GMAP_TOKEN').gmap_place_details(poi)

@restaurant_api = Ewa::Gmap::PlaceApi
@restaurant_api.new

@restaurant_detail_api = Ewa::Gmap::PlaceDetailsApi