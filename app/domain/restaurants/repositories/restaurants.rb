# frozen_string_literal: true

require 'json'

module Ewa
  module Repository
    # Repository for Restaurant Entities
    class Restaurants
      def self.all
        Database::RestaurantOrm.all.map { |db_restaurant| rebuild_entity(db_restaurant) }
      end

      def self.find(entity)
        Database::RestaurantOrm.first(name: entity.name, branch_store_name: entity.branch_store_name)
      end

      def self.find_restaurant_id(entity)
        db_record = Database::RestaurantOrm.first(id: entity.id)
        rebuild_entity(db_record)
      end

      def self.update_reviews2db(entity)
        db_entity = find(entity)
        raise 'Related restaurant not found' unless db_entity

        entity_id = db_entity.id
        raise 'Already five reviews exist' if Reviews.find_all_reviews_by_restaurant_id(entity_id).length > 4

        Reviews.rebuild_many(PersistRestaurant.new(entity).put_reviews_to_db(entity_id))
      end

      def self.update_article2db(entity)
        db_entity = find(entity)
        raise 'Related restaurant not found' unless db_entity

        entity_id = db_entity.id
        raise 'Article exist' if Articles.find_article_by_restaurant_id(entity_id)

        Article.rebuild_entity(PersistRestaurant.new(entity).put_article_to_db(entity_id))
      end

      def self.create(entity)
        raise 'Restaurant already exists' if find(entity)

        # db_restaurant = find(entity)
        # return rebuild_entity(db_restaurant) if db_restaurant

        db_restaurant = PersistRestaurant.new(entity).call
        rebuild_entity(db_restaurant)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        db_record_id = db_record.id

        db_record[:tags] = JSON.parse(db_record[:tags])
        db_record[:open_hours] = JSON.parse(db_record[:open_hours])

        Entity::Restaurant.new(db_record.to_hash.merge(
                                 article: Articles.rebuild_entity(
                                   Articles.find_article_by_restaurant_id(db_record_id), db_record.name
                                 ),
                                 reviews: Reviews.find_all_reviews_by_restaurant_id(db_record_id)
                               ))
      end

      # make sure data goes to database also
      class PersistRestaurant
        def initialize(entity)
          @entity = entity
          @hash_rest = @entity.to_attr_hash
        end

        def create_restaurant
          # delete unused entity fields to input to database
          @hash_rest.delete(:reviews)
          @hash_rest.delete(:article)

          # change type to avoid sequel value misused problem
          @hash_rest[:tags] = @hash_rest[:tags].to_s
          @hash_rest[:open_hours] = @hash_rest[:open_hours].to_s
          Database::RestaurantOrm.create(@hash_rest)
        end

        def call
          # create restaurant to database and get its id
          restaurant_db_entity = create_restaurant
          restaurant_db_entity_id = restaurant_db_entity.id

          # create reviews to database
          put_reviews_to_db(restaurant_db_entity_id)

          # create article to database
          put_article_to_db(restaurant_db_entity_id)

          # return restaurant entity
          restaurant_db_entity
        end

        def put_reviews_to_db(restaurant_db_entity_id)
          reviews = @entity.reviews
          reviews.map do |review|
            Reviews.db_find_or_create(review, restaurant_db_entity_id)
          end
        end

        def put_article_to_db(restaurant_db_entity_id)
          article = @entity.article
          Articles.db_find_or_create(article, restaurant_db_entity_id)
        end
      end
    end
  end
end
