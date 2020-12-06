# frozen_string_literal: true

require 'dry/transaction'

module Ewa
  module Service
    # Retrieves users' browsing history data by searching restaurant id
    class SearchHistory
      include Dry::Transaction
      def call(history_records)
        history = history_records.map do |history_id|
          Repository::For.klass(Entity::Restaurant).find_by_rest_id(history_id)
        end
        Success(history)
      rescue StandardError
        Failure('資料錯誤 Database error!')
      end
    end
  end
end
