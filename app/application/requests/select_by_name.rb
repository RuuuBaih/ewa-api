# frozen_string_literal: true

require 'base64'
require 'dry/monads/result'
require 'json'

module Ewa
  module Request
    # Project list request parser
    class SelectbyName
      include Dry::Monads::Result::Mixin

      def initialize(params)
        @params = params
      end

      # Use in API to parse incoming list requests
      def call
        #@params = @params.to_s.gsub('=>', ':')
        Success(
          @params['name']
        )
      rescue StandardError

        raise "#{JSON.parse(@params)}"

        Failure(
          Response::ApiResult.new(
            status: :bad_request,
            message: 'Name not found'
          )
        )

      end

      # Decode params
      def decode(params)
        Base64.urlsafe_decode64(params)
      end

      # Client App will encode params to send as a string
      # - Use this method to create encoded params for testing
      def self.to_encoded(name)
        Base64.urlsafe_encode64(name.to_json)
      end

      # Use in tests to create a ProjectList object from a list
      def self.to_request(name)
        SelectbyName.new('name' => to_encoded(name))
      end
    end
  end
end