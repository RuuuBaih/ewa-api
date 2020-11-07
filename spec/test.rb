# frozen_string_literal: true

require_relative 'spec_helper'
REST_NAME = '螺絲瑪莉 Rose Mary'

@article_mapper = Ewa::Restaurant::ArticleMapper

puts 'newest_article'
puts @article_mapper.new(REST_NAME).the_newest_article

puts 'new article hash'
puts @article_mapper::BuildArticleEntity.new(ARTICLE_HASH).build_entity

@restaurant_mapper = Ewa::Restaurant::RestaurantMapper

puts 'poi_details'
puts @restaurant_mapper.new(GMAP_TOKEN).poi_details

puts 'restaurant_list'
puts @restaurant_mapper.new(GMAP_TOKEN).restaurant_obj_lists.inspect