# frozen_string_literal: true

# require 'dry/transaction'
require 'dry/monads/all'

module Ewa
  module Service
    # filter restaurants based on money
    class SelectRests
      # include Dry::Transaction
      include Dry::Monads::Result::Mixin
      def call(input)
        # input is a response obj
        params = input.call.value!
        town = params['town']
        min_money = params['min_money']
        max_money = params['max_money']
        random = params['random']
        page = params['page']
        per_page = params['per_page']

    
        selected_entities = Repository::For.klass(Entity::Restaurant)
                                           .find_by_town_money(town, min_money, max_money)
        raise StandardError if selected_entities == []

        total = selected_entities.count

        if random.zero?
          limited_rests = selected_entities.each_slice(per_page).to_a[page - 1]
        else
          limited_rests = selected_entities.sample(random)
        end

        Response::RestaurantsResp.new(total, limited_rests)
                                 .then do |filtered_rests|
          Success(Response::ApiResult.new(status: :ok, message: filtered_rests))
        end
      rescue ArgumentError
        Failure(Response::ApiResult.new(status: :cannot_process, message: '參數錯誤 Invalid input'))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :not_found, message: '無此資料 resource not found'))
      end
    end
  end
end
