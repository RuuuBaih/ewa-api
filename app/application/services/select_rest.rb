# frozen_string_literal: true

require 'dry/transaction'

module Ewa
  module Service
    # filter restaurants based on money
    class SelectRests
      include Dry::Transaction
      def call(town, min_money, max_money)
        selected_entities = Repository::For.klass(Entity::Restaurant)
                                           .find_by_town_money(town, min_money, max_money)
        Response::FilterRestaurantsResp.new(selected_entities)
          .then do |all_rests|
          Success(Response::ApiResult.new(status: :ok, message: all_rests))
        end

      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: '無法獲取資料 Cannot access db'))
      end
    end

    # generate 9 restaurants
    class Pick9Rests
      include Dry::Transaction
      def call(selected_entities)
        rests = Restaurant::RestaurantOptionsMapper.new(selected_entities)
        pick_9rests = rests.random_9picks
        rests_info = Restaurant::RestaurantOptionsMapper::GetRestInfo.new(pick_9rests)
        Response::SearchedRestaurants.new(rests_info)
          .then do |all_rests|
          Success(Response::ApiResult.new(status: :ok, message: all_rests))
        end

      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: '無法獲取資料 Cannot access db'))
      end
    end
  end
end
