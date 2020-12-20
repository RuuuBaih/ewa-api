# frozen_string_literal: true

require 'json'

module Ewa
  module Repository
    # Repository for Cover Pictures Entities
    class CoverPictures
      def self.all
        Database::CoverPictureOrm.all.map { |db_picture| rebuild_entity(db_picture) }
      end

      def self.find_all_cover_pics_by_restaurant_id(restaurant_id)
        rebuild_many Database::CoverPictureOrm.where(restaurant_id: restaurant_id).all
      end

      def self.update(cov_pic_entities)
        cov_pic_entities.map do |cov_pic_entity|
          db_entity = Database::CoverPictureOrm.first(id: cov_pic_entity.id)
          db_entity.update(picture_link: cov_pic_entity.picture_link, article_link: cov_pic_entity.article_link)
          rebuild_entity cov_pic_entity
        end
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::CoverPicture.new(
          id: db_record.id,
          picture_link: db_record.picture_link,
          article_link: db_record.article_link
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_picture|
          CoverPictures.rebuild_entity(db_picture)
        end
      end

      def self.db_find_or_create(entity, restaurant_id)
        hash_entity = entity.to_attr_hash
        hash_entity[:restaurant_id] = restaurant_id
        Database::CoverPictureOrm.find_or_create(hash_entity)
      end
    end
  end
end
