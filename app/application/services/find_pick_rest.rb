# frozen_string_literal: true

require 'dry/transaction'

module Ewa
  module Service
    # find picked restaurants by restaurant id
    class FindPickRest
      include Dry::Transaction
      def call(rest_id)
        rest_detail = Repository::For.klass(Entity::Restaurant).find_by_rest_id(rest_id)
        Response::SearchedRestaurants.new(rest_detail)
          .then do |all_rests|
          Success(Response::ApiResult.new(status: :ok, message: all_rests))
        end

      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: '無法獲取資料 Cannot access db'))
      end
    end
  end
end
