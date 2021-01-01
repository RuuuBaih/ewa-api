# frozen_string_literal: true

# require 'dry/transaction'
require 'dry/monads/all'

module Ewa
  module Service
    # filter restaurants based on money
    class ShowAllRests
      # include Dry::Transaction
      include Dry::Monads::Result::Mixin

      def call(input)
        params = input.call.value!
        page = params['page']
        per_page = params['per_page']

        restaurants = Repository::For.klass(Entity::Restaurant).all_desc_order_by_clicks
        total = restaurants.count

        # slice restaurants(array of entities) into pieces
        limited_rests = restaurants.each_slice(per_page).to_a[page - 1]

        resp = Response::RestaurantsResp.new(total, limited_rests)
                                        .then do |all_rests|
          Success(Response::ApiResult.new(status: :ok, message: all_rests))
        end
      rescue ArgumentError
        Failure(Response::ApiResult.new(status: :cannot_process, message: '參數錯誤 Invalid input'))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: '無法獲取資料 Cannot access db'))
      end
    end
  end
end
