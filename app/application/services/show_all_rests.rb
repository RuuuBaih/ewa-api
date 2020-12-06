# frozen_string_literal: true

require 'dry/transaction'

module Ewa
  module Service
    # filter restaurants based on money
    class ShowAllRests
      include Dry::Transaction

      def call
        restaurants = Repository::For.klass(Entity::Restaurant).all

        Response::AllRestaurantsResp.new(restaurants)
          .then do |all_rests|
          Success(Response::ApiResult.new(status: :ok, message: all_rests))
        end

      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: '無法獲取資料 Cannot access db'))
      end
    end
  end
end
