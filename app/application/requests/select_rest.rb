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
          output_with_random_obj
        )
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :bad_request,
            message: 'Related resources not found'
          )
        )
      end

      def output_with_random_obj
        #binding.irb
        random = @params.key?('random') ? @params['random'].to_i : 0
        @params["random"] = random

        if random.zero?
          # default page is 1 and records on per page is 5
          # which page
          page = @params.key?('page') ? @params['page'].to_i : 1
          @params["page"] = page

          # how many records on per page
          # 5 can be changed in the future
          per_page = @params.key?('per_page') ? @params['per_page'].to_i : 9
          @params["per_page"] = per_page

          # records on per page can be up than 10
          # 10 can be changed in the future
          raise StandardError if per_page > 10

          # input invalid
          raise ArgumentError if page.zero? || per_page.zero?
        end
        @params
      end
    end
  end
end
