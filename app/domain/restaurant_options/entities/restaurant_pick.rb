# frozen_string_literal: true

module Ewa
  module Entity
    # Aggregate root for contributions domain
    class RestaurantPick < SimpleDelegator

      def initialize(restaurant_9picks, choice_num)
          @restaurant_9picks = restaurant_9picks
          @choice_num = choice_num
          @rest_pick = @restaurant_9picks[@choice_num]
      end

      def ewa_tag_hash
         # hope to return a ewa tag hash back 
         # (e.g. {"restaurant_id": id, "ewa_tag": ewa_tag})
         Value::EwaTags.new(
             @rest_pick.id, # restaurant_id
             @rest_pick.money,
             @rest_pick.google_rating
         )
      end

      def ewa_tag_build_entity(ewa_tag_hash)
          Entity::EwaTag.new(
            id:nil,
            restaurant_id: ewa_tag_hash[:restaurant_id],
            ewa_tag: ewa_tag_hash[:ewa_tag]
          )
      end
    end
  end
end
