# frozen_string_literal: true

require 'dry/transaction'

module Ewa
  module Service
    # select random restaurant ids based on the id lists pool and how many rest ids wanna get back
    class SelectRandomRestList
      include Dry::Transaction
      # Note:
      #   ids: list of ids
      #   num: how many random ids want to pick
      def call(ids, num)
        random_ids = ids.sample(num)
        Success(random_ids)
      rescue StandardError
        Failure('參數格式錯誤')
      end
    end
  end
end
