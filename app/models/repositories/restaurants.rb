# frozen_string_literal: true

module Ewa
    module Repository
      # Repository for Restaurant Entities
      class Restaurants
        def self.all
          Database::RestaurantOrm.all.map { |db_restaurant| rebuild_entity(db_restaurant) }
        end
  
        def self.find(entity)
          find_restaurant_id(entity.id)
        end
  
        def self.find_restaurant_id(restaurant_id)
          db_record = Database::RestaurantOrm.first(id: restaurant_id)
          rebuild_entity(db_record)
        end
  
        private
  
        def self.rebuild_entity(db_record)
          return nil unless db_record

          db_record[:tags] = db_record[:tags].split(/, /)
  
          Entity::Restaurant.new(
            db_record.to_hash.merge(
              article: Articles.find_article_by_restaurant_id(db_record.id, db_record.name),
              reviews: Reviews.find_all_reviews_by_restaurant_id(db_record.id)
            )
          )
        end
      end
    end
  end
