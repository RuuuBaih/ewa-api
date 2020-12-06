# frozen_string_literal: true

require 'dry/transaction'

module Ewa
  module Service
    # filter restaurants based on money
    class ShowAllRests
      include Dry::Transaction
      def call
        restaurants = Repository::For.klass(Entity::Restaurant).all
        Success(restaurants)
      rescue StandardError
        Failure('資料錯誤 Data error!')
      end
    end
  end
end
