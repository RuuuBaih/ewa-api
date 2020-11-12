# frozen_string_literal: true


module Ewa
  module Mapper
    # Get filtered restaurant_pick
    class RestaurantPick

      def initialize(restaurant_9picks, choice_num)
        @rest_9picks = restaurant_9picks
        @choice_num = choice_num
      end

      def build_entity
        Entity::RestaurantPick.new(
            @rest_9picks,
            @choice_num
        )
      end

      def restaurant_1pick
         rest_1pick = build_entity
         hash = rest_1pick.ewa_tag_hash
         ewa_tag_entity = rest_pick.ewa_tag_build_entity(hash)
         # return a hash of restaurant pick entity & ewa tag entity
         {rest_pick: rest_1pick.rest_pick, ewa_tag_entity: ewa_tag_entity]
      end
    end
  end
end
