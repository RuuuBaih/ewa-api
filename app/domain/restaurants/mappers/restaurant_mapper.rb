# frozen_string_literal: false

require_relative '../gateways/gmap_api'
require_relative '../gateways/pix_api'
require_relative '../entities/restaurant'
require_relative '../entities/review'
require_relative '../entities/article'
require_relative '../mappers/review_mapper'
require_relative '../mappers/article_mapper'

module Ewa
  # Provides access to restuarant sites lists data
  module Restaurant
    # Data Mapper: Pixnet POI, Gmap Place & Place details -> Restuarant entity
    class RestaurantMapper
      def initialize(
        gmap_token,
        gateway_classes = {
          pixnet: Pixnet::PoiApi,
          gmap_place: Gmap::PlaceApi,
          gmap_place_details: Gmap::PlaceDetailsApi
        }
      )
        @token = gmap_token
        @gateway_classes = gateway_classes
      end

      # get poi full details
      def poi_details
        pix_gateway_class = @gateway_classes[:pixnet]
        pix_gateway = pix_gateway_class.new(1, 50)
        pix_gateway.poi_lists['data']['pois'].reduce([]) do |start, hash|
          start << FilterHash.new(hash).filtered_poi_hash
        end
      end

      # get google map place full details
      def gmap_place_details(poi_filtered_hash)
        place_name = poi_filtered_hash['name'].gsub(' ', '')
        gmap_place_gateway = @gateway_classes[:gmap_place].new(@token, place_name)
        if gmap_place_gateway.place_id['candidates'].length.zero?
          nil
        else
          place_id = gmap_place_gateway.place_id['candidates'][0]['place_id']
          @gateway_classes[:gmap_place_details].new(@token, place_id).place_details
        end
      end

      # get filtered and aggregated restaurant object lists
      def restaurant_obj_lists
        poi_filtered_hashes = poi_details.map do |hash|
          place_details = gmap_place_details(hash)
          if place_details.nil?
            hash.clear
          else
            AggregatedRestaurantObjs.new(hash, place_details).aggregate_restaurant_objs
          end
        end

        # filter nil results
        poi_filtered_hashes.delete_if(&:empty?)

        RestaurantMapper::BuildRestaurantEntity.new(poi_filtered_hashes).build_entity
      end

      # build Restaurant Entity
      class BuildRestaurantEntity
        def initialize(array_of_hashes)
          @array_of_hashes = array_of_hashes
        end

        def build_entity
          @array_of_hashes.map do |hash|
            DataMapper.new(hash).build_entity
          end
        end
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        # rubocop:disable Metrics/MethodLength
        def build_entity
          Ewa::Entity::Restaurant.new(
            id: nil,
            name: name,
            town: town,
            city: city,
            open_hours: open_hours,
            telephone: telephone,
            cover_img: cover_img,
            tags: tags,
            money: money,
            pixnet_rating: pixnet_rating,
            google_rating: google_rating,

            reviews: reviews,
            article: article
          )
        end
        # rubocop:enable Metrics/MethodLength

        private

        def name
          @data['name']
        end

        def town
          @data['town']
        end

        def city
          @data['city']
        end

        def open_hours
          @data['open_hours']
        end

        def telephone
          @data['telephone']
        end

        def cover_img
          @data['cover_img']
        end

        def tags
          @data['tags']
        end

        def money
          @data['money']
        end

        def pixnet_rating
          @data['pixnet_rating'].to_f
        end

        def google_rating
          @data['google_rating'].to_f
        end

        def reviews
          ReviewMapper::BuildReviewEntity.new(@data['reviews']).build_entity
        end

        def article
          article = ArticleMapper.new(@data['name']).the_newest_article
          ArticleMapper::BuildArticleEntity.new(article).build_entity
        end
      end
    end

    # Aggregate poi & gmap place informations
    class AggregatedRestaurantObjs
      def initialize(poi_hash, place_hash)
        @restaurant_hash = poi_hash
        @place_rets = place_hash['result']
      end

      # get each aggregated restaurant obj ( Aggregate Pixnet POI, Gmap Place & Place details )
      def aggregate_restaurant_objs
        open_hours
        google_rating
        reviews

        @restaurant_hash
      end

      private

      def open_hours
        if !@place_rets.key?('opening_hours')
          open_week = @restaurant_hash['open_hours']['date']
          @restaurant_hash['open_hours'] = ["星期一: #{open_week['Mo']}", "星期二: #{open_week['Tu']}",
                                            "星期三: #{open_week['We']}", "星期四: #{open_week['Th']}",
                                            "星期五: #{open_week['Fr']}", "星期六: #{open_week['Sa']}",
                                            "星期日: #{open_week['Sun']}"]

        else
          @restaurant_hash['open_hours'] = @place_rets['opening_hours']['weekday_text']
        end
      end

      def google_rating
        @restaurant_hash['google_rating'] = @place_rets['rating']
      end

      def reviews
        @restaurant_hash['reviews'] = @place_rets['reviews'].reduce([]) do |start, hash|
          start << FilterHash.new(hash).filtered_gmap_place_details_hash
        end
      end
    end

    # Use to filter hashes
    class FilterHash
      def initialize(hash)
        @hash = hash
      end

      # filter the poi fields, select what we want
      # rubocop:disable Metrics/MethodLength
      def filtered_poi_hash
        addr = @hash['address']
        {
          'name' => @hash['name'],
          'money' => @hash['money'],
          'telephone' => @hash['telephone'],
          'cover_img' => @hash['cover_image_url'],
          'tags' => @hash['tags'],
          'pixnet_rating' => @hash['rating']['avg'],
          'city' => addr['city'],
          'town' => addr['town'],
          'open_hours' => @hash['opening_hours_info']
        }
      end
      # rubocop:enable Metrics/MethodLength

      # filter the gmap place details fields, select what we want
      def filtered_gmap_place_details_hash
        @hash.select do |key, _value|
          key_lists = %w[
            author_name
            profile_photo_url
            rating
            text
            relative_time_description
          ]
          key_lists.include? key
        end
      end
    end
  end
end
