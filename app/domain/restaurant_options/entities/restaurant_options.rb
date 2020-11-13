# frozen_string_literal: true

module Ewa
  module Entity
    # Aggregate root for restaurant_options domain
    class RestaurantOptions < SimpleDelegator
      def initialize(restaurant_repo_entities, city, town, min_money, max_money)
        super()
        @restaurant_repo_entities = restaurant_repo_entities
        @hash = [
          city: city,
          town: town,
          min_money: min_money,
          max_money: max_money
        ]
      end

      def city_filter(rest_repo_entities)
        rest_repo_entities.select do |rest_repo_entity|
          rest_repo_entity['city'] == @hash[:city]
        end
      end

      def town_filter(rest_repo_entities)
        rest_repo_entities.select do |rest_repo_entity|
          rest_repo_entity['town'] == @hash[:town]
        end
      end

      def money_filter(rest_repo_entities)
        rest_repo_entities.select do |rest_repo_entity|
          rest_repo_entity['money'].between(@hash[:min_money], @hash[:max_money])
        end
      end

      def aggregate_filter
        city_filtered = city_filter(@restaurant_repo_entities)
        town_filtered = town_filter(city_filtered)
        money_filter(town_filtered)
      end
    end
  end
end
