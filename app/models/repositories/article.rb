# frozen_string_literal: true

module Ewa
  module Repository
    # Repository for Articles
    class Articles
      def self.find_article_by_id(id)
        rebuild_entity Database::ArticleOrm.first(article_id: id)
      end

      def self.find_article_by_restaurant_name(name)
        rebuild_entity Database::ArticleOrm.first(restaurant_name: name)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Article.new(
          article_id: db_record.article_id,
          restaurant_name: db_record.restaurant_name,
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
