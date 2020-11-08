# frozen_string_literal: true

module Ewa
    module Repository
      # Repository for Restaurant Entities
      class Restaurants
        def self.all
          Database::RestaurantOrm.all.map { |db_restaurant| rebuild_entity(db_restaurant) }
        end
  
        def self.find(entity)
          find_restaurant_id(entity.restaurant_id)
        end
  
        def self.find_restaurant_id(restaurant_id)
          db_record = Database::RestaurantOrm.first(restaurant_id: restaurant_id)
          rebuild_entity(db_record)
        end
  
        private
  
        def self.rebuild_entity(db_record)
          return nil unless db_record
  
          Entity::Restaurant.new(
            db_record.to_hash.merge(
              article: Articles.rebuild_entity(Articles.find_article_by_id(db_record.article_id)),
              reviews: [Reviews.rebuild_entity(Reviews.find_review_by_id(db_record.review_id))]
            )
          )
        end
      end
    end
  end
