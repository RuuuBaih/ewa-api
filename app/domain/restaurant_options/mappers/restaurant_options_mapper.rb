# frozen_string_literal: true

module Ewa
  module Mapper
    # Get filtered restaurant_repo_entites
    class RestaurantOptions
      def initialize(restaurant_repo_entities, _city, town, min_money, max_money)
        @restaurant_repo_entities = restaurant_repo_entities
        @town = town
        @min_money = min_money
        @max_money = max_money
      end

      def build_entity
        Entity::RestaurantOptions.new(
          @restaurant_repo_entities,
          @town,
          @min_money,
          @max_money
        )
      end

      def all_restaurant_options
        build_entity.aggregate_filter
      end

      def random_9picks(filtered_all)
        filtered_all.sample(9)
      end

      def restaurant_1pick(all_options, choice_num)
        # all options = all_restaurant_options called
        RestaurantPick.new(
          random_9picks(all_options),
          choice_num
        ).restaurant_1pick
      end
    end
  end
end
