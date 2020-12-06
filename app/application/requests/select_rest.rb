# frozen_string_literal: true

require 'base64'
require 'dry/monads/result'
require 'json'

module Ewa
  module Request
    # Project list request parser
    class SelectRests
      include Dry::Monads::Result::Mixin

      def initialize(params)
        @params = params
      end

      # Use in API to parse incoming list requests
      def call
        Success(
          JSON.parse(decode(@params['town'], @params['min_money'], @params['max_money']))
        )
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :bad_request,
            message: 'Project list not found'
          )
        )
      end

      # Decode params
      def decode(town, min_money, max_money)
        Base64.urlsafe_decode64(town, min_money, max_money)
      end

      # Client App will encode params to send as a string
      # - Use this method to create encoded params for testing
      def self.to_encoded(output)
        Base64.urlsafe_encode64(output.to_json)
      end

      # Use in tests to create a ProjectList object from a list
      def self.to_request(town, min_money, max_money)
        SelectRests.new('town' => to_encoded(town))
        SelectRests.new('min_money' => to_encoded(min_money))
        SelectRests.new('max_money' => to_encoded(max_money))
      end
    end
  end
end