# frozen_string_literal: true

require_relative 'helpers/spec_helper'
REST_NAME = '螺絲瑪莉 Rose Mary'
# @article_mapper = Ewa::Restaurant::ArticleMapper
#
# puts 'newest_article'
# puts @article_mapper.new(REST_NAME).the_newest_article
@restaurant_mapper = Ewa::Restaurant::RestaurantMapper
#=begin
# puts 'poi_details'
poi = @restaurant_mapper.new(GMAP_TOKEN).PoiDetails.poi_details
puts poi
puts poi.length
puts poi.class
puts poi[0]['category_id']
#=end
restaurant_entities = Ewa::Restaurant::RestaurantMapper.new(GMAP_TOKEN).restaurant_obj_lists[2]
puts restaurant_entities
=begin
restaurant_repo_entities = restaurant_entities.map do |restaurant_entity|
    Ewa::Repository::For.entity(restaurant_entity).create(restaurant_entity)
end

puts restaurant_repo_entities

# puts @restaurant_mapper.new(GMAP_TOKEN).gmap_place_details(poi)[place_id]

puts 'restaurant_list'
# puts @restaurant_mapper.new(GMAP_TOKEN).restaurant_obj_lists[0][:reviews]
# puts @restaurant_mapper.new(GMAP_TOKEN).gmap_place_details(poi)[place_id]
place_name = '螺絲瑪莉'
GMAP_API_PATH = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?'

@gateway_classes = Ewa::Gmap::PlaceApi
puts @gateway_classes.new('GMAP_TOKEN', place_name).place_id['candidates'].empty?
=end