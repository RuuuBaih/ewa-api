# frozen_string_literal: true

require 'dry/monads/result'
require 'json'

module Ewa
  module Request
    # Project list request parser
    class SelectbyTown
      include Dry::Monads::Result::Mixin

      def initialize(params)
        @params = params
      end

      # Use in API to parse incoming list requests
      def call
        binding.irb

        Success(
          @params['town'],
          @params['min_money'],
          @params['max_money']
        )
      rescue StandardError
        raise JSON.parse(@params).to_s

        Failure(
          Response::ApiResult.new(
            status: :bad_request,
            message: 'Town not found'
          )
        )
      end
    end
  end
end
