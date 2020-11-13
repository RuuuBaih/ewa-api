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

      # Pick one restaurant to show details
      class PickOne
        def initialize(all_options, choice_num)
          @all_options = all_options
          @choice_num = choice_num
        end

        def restaurant_1pick
          # all options = all_restaurant_options called
          RestaurantPick.new(
            Random.new(@all_options)._9picks,
            @choice_num
          ).restaurant_1pick
        end
      end

      # Get random pics of restaurants
      class Random
        def initialize(filtered_all)
          @filtered_all = filtered_all
        end

        def _9picks
          @filtered_all.sample(9)
        end
      end
    end
  end
end
