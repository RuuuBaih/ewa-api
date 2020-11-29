# frozen_string_literal: true

require 'dry/transaction'

module Ewa
  module RestaurantOthers
    # Retrieves restaurant entity by searching restaurant name
    class History_id
      include Dry::Transaction
      def call(history_records)
        history_ID = history_records.map do |history_id|
          Repository::For.klass(Entity::Restaurant).find_by_rest_id(history_id).id
        end
        Success(history_ID)
        rescue StandardError
          Failure('資料錯誤 Database error!')
      end
    end

    class History_name
      include Dry::Transaction
      def call(history_records)
        history_name = history_records.map do |history_id|
          Repository::For.klass(Entity::Restaurant).find_by_rest_id(history_id).name
        end
        Success(history_name)
        rescue StandardError
          Failure('資料錯誤 Database error!')
      end
    end
  end
end