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
        Success(rest_pick_id)
      rescue StandardError
        Failure('無此餐廳 Restaurant is not found.')
      end
    end
  end
end
