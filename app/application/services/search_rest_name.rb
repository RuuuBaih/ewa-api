# frozen_string_literal: true

# require 'dry/monads'
require 'dry/transaction'

module Ewa
  module Service
    # Retrieves restaurant entity by searching restaurant name
    class SearchRestName
      include Dry::Transaction
      # include Dry::Monads::Result::Mixin

      def call(search)
        # random pick one of the search, if the names are the same.
        # e.g. In db: ABC小館 DEF小館 --> user search "小館" will random show one of two
        rest_pick_id = (Repository::For.klass(Entity::Restaurant).rest_convert2_id(search)).sample(1)[0].id
        rest_detail = Repository::For.klass(Entity::Restaurant).find_by_rest_id(rest_pick_id)
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
