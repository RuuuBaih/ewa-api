# frozen_string_literal: true

module Ewa
  module Repository
    # Repository for Articles
    class Articles
      def self.find_article_by_id(id, restaurant_name)
        rebuild_entity(Database::ArticleOrm.first(id: id), restaurant_name)
      end

      def self.find_article_by_restaurant_id(restaurant_id, restaurant_name)
        rebuild_entity(Database::ArticleOrm.first(restaurant_id: restaurant_id), restaurant_name)
      end

      def self.rebuild_entity(db_record, restaurant_name)
        return nil unless db_record

        Entity::Article.new(
          id: db_record.id,
          restaurant_name: restaurant_name, 
          restaurant_id: db_record.restaurant_id,
          link: db_record.link
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_article|
          Articles.rebuild_entity(db_article)
        end
      end

      def self.db_find_or_create(entity)
        Database::ArticleOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
