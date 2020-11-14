# frozen_string_literal: true

require_relative 'helpers/spec_helper'
REST_NAME = '螺絲瑪莉 Rose Mary'
# @article_mapper = Ewa::Restaurant::ArticleMapper
#
# puts 'newest_article'
# puts @article_mapper.new(REST_NAME).the_newest_article
@restaurant_mapper = Ewa::Restaurant::RestaurantMapper
=begin
# puts 'poi_details'
poi = @restaurant_mapper.new(GMAP_TOKEN).PoiDetails.poi_details
puts poi
puts poi.length
puts poi.class
puts poi[0]['category_id']
=end
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

@money = 500
@google_rating = 4.8

if @money >= 1000 && @google_rating >= 4.5
    ewa_tag = '老闆請客 Boss, please treat me!'
elsif @money >= 1000 && 4.5 > @google_rating >= 4
    ewa_tag = '存點錢再吃  Eat when you have budget!'
elsif @money.between?(500, 1000) && @google_rating >= 4.5
    ewa_tag = '女朋友叫你帶她去吃 Girlgfriend said she want to eat that!'
else
    ewa_tag = '哎呀還行拉 So~so!'
end

=begin
if @money >= 1000 && @google_rating >= 4.5
    ewa_tag = '老闆請客 Boss, please treat me!'
elsif @money >= 1000 && 4.5 > @google_rating >= 4
    ewa_tag = '存點錢再吃  Eat when you have budget!'
elsif 1000 >= @money > 500 && @google_rating >= 4.5
    ewa_tag = '女朋友叫你帶她去吃 Girlgfriend said she want to eat that!'
elsif 1000 >= @money > 500 && 4.5 > @google_rating >= 4
    ewa_tag = '同學會可食 Eat this in the class reunion!'
elsif 300 <= @money < 500 && @google_rating >= 4.5
    ewa_tag = '發薪日可食 Eat when you get your salary!'
elsif 300 <= @money < 500 && 4.5 > @google_rating >= 4
    ewa_tag = '吃拉，哪吃不吃~ Ok, just eat that.'
elsif 0 < @money < 300 && @google_rating >= 4.5
    ewa_tag = '便宜上天堂 Go to heaven~'
elsif 0 < @money < 300 && 4.5 > @google_rating >= 4
    ewa_tag = 'cp值爆高 Cheap and happy!'
elsif 0 < @money < 300 && @google_rating <= 3.5
    ewa_tag = '維持生命 Only maintain my life'
elsif @money > 300 && @google_rating <= 3.5
    ewa_tag = '痛苦盤子 Eat sh**!'
elsif @money == 0
    ewa_tag = '查無價格 No price'
else
    ewa_tag = '哎呀還行拉 So~so!'
end
=end
puts ewa_tag