# frozen_string_literal: true

require 'dry/monads/all'
# require 'dry/transaction'

module Ewa
  module Service
    # Retrieves restaurant entity by searching restaurant name
    class SearchRestName
      # include Dry::Transaction
      include Dry::Monads::Result::Mixin

      def call(input)
        # pick all of the search, if the names are the same.
        # e.g. In db: ABC小館 DEF小館 --> user search "小館" will show both of two
        # search is a response obj
        search = input.call.value!
        rest_searches = Repository::For.klass(Entity::RestaurantDetail).rest_convert2_id(search)
        # if database results not found
        raise StandardError if rest_searches == []

        # if searches have more than 5 records, than show only five records
        rest_searches = rest_searches[0..4] if rest_searches.length > 5

        Response::SearchRestaurantResp.new(rest_searches)
                                      .then do |searches|
          Success(Response::ApiResult.new(status: :ok, message: searches))
        end
      rescue StandardError
        Failure(Response::ApiResult.new(status: :not_found, message: '無此資料 Resource not found'))
      end
    end
  end
end
