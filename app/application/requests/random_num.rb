# frozen_string_literal: true

require 'base64'
require 'dry/monads/result'
require 'json'

module Ewa
  module Request
    # Project list request parser
    class RandomNum
      include Dry::Monads::Result::Mixin

      def initialize(params)
        @params = params
      end

      # Use in API to parse incoming list requests
      def call
        Success(
          JSON.parse(decode(@params['num']))
        )
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :bad_request,
            message: 'Number not found'
          )
        )
      end

      # Decode params
      def decode(params)
        Base64.urlsafe_decode64(params)
      end

      # Client App will encode params to send as a string
      # - Use this method to create encoded params for testing
      def self.to_encoded(num)
        Base64.urlsafe_encode64(num.to_json)
      end

      # Use in tests to create a ProjectList object from a list
      def self.to_request(num)
        EncodedProjectList.new('number' => to_encoded(num))
      end
    end
  end
end