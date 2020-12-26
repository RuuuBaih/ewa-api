# frozen_string_literal: true

# require 'dry/transaction'
require 'dry/monads/all'
require_relative '../../domain/restaurant_options/mappers/restaurant_options_mapper'

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

        # get rests filter by town and money  
        selected_entities = Repository::For.klass(Entity::Restaurant)
                                           .find_by_town_money(town, min_money, max_money)


        # get option entities
        option_entities = Restaurant::RestaurantOptionsMapper.new(selected_entities, random, page, per_page)

        # get total number of option entities
        total = option_entities.total
       
        # get random picks  
        pick_entities = option_entities.random_picks

        Response::RestaurantsResp.new(total, pick_entities)
                                 .then do |pick_rests|
          Success(Response::ApiResult.new(status: :ok, message: pick_rests))
        end
      rescue ArgumentError
        Failure(Response::ApiResult.new(status: :cannot_process, message: '參數錯誤 Invalid input'))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :not_found, message: '無此資料 resource not found'))
      end
    end
  end
end
