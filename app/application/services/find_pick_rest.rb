# frozen_string_literal: true

# require 'dry/transaction'
require 'dry/monads'

module Ewa
  module Service
    # find picked restaurants by restaurant id
    class FindPickRest
      # include Dry::Transaction
      include Dry::Monads::Result::Mixin
      def call(rest_id)

        rest_detail = Repository::For.klass(Entity::Restaurant).find_by_rest_id(rest_id)
        # if database results not found
        if rest_detail.nil?
          raise StandarError
        end

        Response::PickRestaurantResp.new(rest_detail)
          .then do |rest_details|
          Success(Response::ApiResult.new(status: :ok, message: rest_details))
        end

        
      rescue StandardError
        Failure(Response::ApiResult.new(status: :not_found, message: '無此資料 Resource not found'))
      end
    end
  end
end
