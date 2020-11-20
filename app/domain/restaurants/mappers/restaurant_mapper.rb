# frozen_string_literal: false

# require_relative '../../restaurant_options/mappers/restaurant_pick_mapper'
require_relative '../../restaurant_options/init'

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
      class PoiDetails
        def initialize(pix_gateway_class)
          @poi_hashes = []
          @filter = nil
          @cities = %w[台北市 新北市]
          @pix_gateway_class = pix_gateway_class
        end

        def poi_details
          start = []
          multi_pages.map do |hash|
            @filter = FilterHash.new(hash).filtered_poi_hash
            start << @filter if (@filter['category_id']).zero? && (@filter['money'] != 0)
          end
          start
        end

        # get multi pages of results from new taipei city & taipei city
        def multi_pages
          1.upto(3) do |item|
            iterate_pois(item)
          end
          @poi_hashes.flatten
        end

        def iterate_pois(item)
          @cities.map do |tp_city|
            @poi_hashes << @pix_gateway_class.new(item, 5, tp_city).poi_lists['data']['pois']
          end
        end
      end

      # get google map place full details
      def gmap_place_details(poi_filtered_hash)
        place_name = FoolProof.new(poi_filtered_hash).check_gmap_place_name
        gmap_place_gateway = @gateway_classes[:gmap_place].new(@token, place_name)
        place_id = gmap_place_gateway.place_id['candidates']
        if place_id.length.zero?
          {}
        else
          @gateway_classes[:gmap_place_details].new(@token, place_id[0]['place_id']).place_details['result']
        end
      end

      def aggregate_rest_hashes
        pix_gateway_class = @gateway_classes[:pixnet]
        PoiDetails.new(pix_gateway_class).poi_details.map do |poi_hash|
          place_details = gmap_place_details(poi_hash)
          FoolProof.new(place_details).check_aggregate(poi_hash)
        end
      end

      # try to avoid some situations
      class FoolProof
        def initialize(hash)
          @hash = hash
        end

        # try to avoid the restaurants without reviews and photos
        def check_aggregate(poi_hash)
          if (@hash != {}) && @hash.key?('reviews') && @hash.key?('photos')
            AggregatedRestaurantObjs.new(poi_hash, @hash).aggregate_restaurant_objs
          else
            hash.clear
          end
        end

        # try to search with restaurant name & branch store name or restaurant name & town
        # try to avoid getting results from the wrong branch store or town
        def check_gmap_place_name
          branch_name = @hash['branch_store_name']
          name = @hash['name']
          if branch_name != ''
            "#{name}#{branch_name}".gsub(' ', '')
          else
            "#{name}#{@hash['town']}".gsub(' ', '')
          end
        end
      end

      # get filtered and aggregated restaurant object lists
      def restaurant_obj_lists
        # filter nil results
        filtered_nil_hashes = aggregate_rest_hashes
        filtered_nil_hashes.delete_if(&:empty?)

        RestaurantMapper::BuildRestaurantEntity.new(filtered_nil_hashes, @token).build_entity
      end

      # build Restaurant Entity
      class BuildRestaurantEntity
        def initialize(array_of_hashes, token)
          @array_of_hashes = array_of_hashes
          @token = token
        end

        def build_entity
          @array_of_hashes.map do |hash|
            DataMapper.new(hash, @token).build_entity
          end
        end
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data, token)
          @data = data
          @token = token
        end

        # rubocop:disable Metrics/MethodLength
        # rubocop:disable Metrics/AbcSize
        def build_entity
          Ewa::Entity::Restaurant.new(
            id: nil,
            name: @data['name'],
            branch_store_name: @data['branch_store_name'],
            town: @data['town'],
            city: @data['city'],
            open_hours: @data['open_hours'],
            telephone: @data['telephone'],
            cover_img: @data['cover_img'],
            tags: @data['tags'],
            money: @data['money'],
            pixnet_rating: @data['pixnet_rating'].to_f,
            google_rating: @data['google_rating'].to_f,
            address: @data['address'],
            website: @data['website'],
            reviews: reviews,
            pictures: pictures,
            article: article,
            ewa_tag: ewa_tag
          )
        end
        # rubocop:enable Metrics/MethodLength
        # rubocop:enable Metrics/AbcSize

        private

        def reviews
          ReviewMapper::BuildReviewEntity.new(@data['reviews']).build_entity
        end

        def article
          article = ArticleMapper.new(@data['name']).the_newest_article
          ArticleMapper::BuildArticleEntity.new(article).build_entity
        end

        def pictures
          pictures = PictureMapper.new(@token, @data['photos']).photo_lists
          PictureMapper::BuildPictureEntity.new(pictures).build_entity
        end

        def ewa_tag
          ewa_tag_hash = RestaurantPickMapper.new(@data).ewa_tag
          RestaurantPickMapper::BuildEwaTagEntity.new(ewa_tag_hash).build_entity
        end
      end
    end

    # Aggregate poi & gmap place informations
    class AggregatedRestaurantObjs
      def initialize(poi_hash, place_hash)
        @restaurant_hash = poi_hash
        @place_rets = place_hash
        @open_week = @restaurant_hash['open_hours']['date']
      end

      # get each aggregated restaurant obj ( Aggregate Pixnet POI, Gmap Place & Place details )
      def aggregate_restaurant_objs
        filter
        @restaurant_hash
      end

      private

      def filter
        address_website
        open_hours
        google_rating
        reviews
        photos
      end

      def address_website
        @restaurant_hash['address'] = @place_rets['formatted_address']
        @restaurant_hash['website'] = if !@place_rets.key?('website')
                                        @restaurant_hash['website']['website']
                                      else
                                        @place_rets['website']
                                      end
      end

      def open_hours
        if !@place_rets.key?('opening_hours')
          @restaurant_hash['open_hours'] = ["星期一: #{@open_week['Mo']}", "星期二: #{@open_week['Tu']}",
                                            "星期三: #{@open_week['We']}", "星期四: #{@open_week['Th']}",
                                            "星期五: #{@open_week['Fr']}", "星期六: #{@open_week['Sa']}",
                                            "星期日: #{@open_week['Sun']}"]

        else
          @restaurant_hash['open_hours'] = @place_rets['opening_hours']['weekday_text']
        end
      end

      def google_rating
        @restaurant_hash['google_rating'] = @place_rets['rating']
      end

      def reviews
        @restaurant_hash['reviews'] = @place_rets['reviews'].reduce([]) do |start, hash|
          start << FilterHash.new(hash).filtered_gmap_place_reviews_hash
        end
      end

      def photos
        @restaurant_hash['photos'] = @place_rets['photos'].reduce([]) do |start, hash|
          start << FilterHash.new(hash).filtered_gmap_place_photos_hash
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
          'category_id' => @hash['category_id'],
          'name' => @hash['name'],
          'branch_store_name' => @hash['branch_store_name'],
          'money' => @hash['money'],
          'telephone' => @hash['telephone'],
          'cover_img' => @hash['cover_image_url'],
          'tags' => @hash['tags'],
          'pixnet_rating' => @hash['rating']['avg'],
          'city' => addr['city'],
          'town' => addr['town'],
          'open_hours' => @hash['opening_hours_info'],
          'website' => @hash['urls']
        }
      end
      # rubocop:enable Metrics/MethodLength

      # filter the gmap place reviews fields, select what we want
      def filtered_gmap_place_reviews_hash
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

      # filter the gmap place photos fields, select what we want
      def filtered_gmap_place_photos_hash
        @hash.select do |key, _value|
          key_lists = %w[
            photo_reference
          ]
          key_lists.include? key
        end
      end
    end
  end
end
