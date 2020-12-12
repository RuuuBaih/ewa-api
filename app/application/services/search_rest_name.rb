# frozen_string_literal: true

# require 'dry/monads'
require 'dry/transaction'

module Ewa
  module Service
    # Retrieves restaurant entity by searching restaurant name
    class SearchRestName
      include Dry::Transaction
      # include Dry::Monads::Result::Mixin

<<<<<<< HEAD
      def call(search)
        # random pick one of the search, if the names are the same.
        # e.g. In db: ABC小館 DEF小館 --> user search "小館" will random show one of two
        rest_pick_id = (Repository::For.klass(Entity::Restaurant).rest_convert2_id(search)).sample(1)[0].id
        rest_detail = Repository::For.klass(Entity::Restaurant).find_by_rest_id(rest_pick_id)
        Response::SearchedRestaurants.new(rest_detail)
          .then do |all_rests|
          Success(Response::ApiResult.new(status: :ok, message: all_rests))
=======
      def call(input)
        # pick all of the search, if the names are the same.
        # e.g. In db: ABC小館 DEF小館 --> user search "小館" will show both of two
        # search is a response obj
        search = input.call.value!
        rest_searches = Repository::For.klass(Entity::Restaurant).rest_convert2_id(search)
        # if database results not found
        if rest_searches == []
          raise StandardError
        end

        # if searches have more than 5 records, than show only five records
        if rest_searches.length > 5
          rest_searches = rest_searches[0..4]
        end

        Response::SearchRestaurantResp.new(rest_searches)
          .then do |searches|
          Success(Response::ApiResult.new(status: :ok, message: searches))
>>>>>>> origin
        end

      rescue StandardError
        Failure(Response::ApiResult.new(status: :not_found, message: '無此資料 Resource not found'))
      end
    end
  end
end
