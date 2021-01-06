# frozen_string_literal: true

require 'dry/monads/all'

module Ewa
  module Service
    # find picked restaurants by restaurant id
    class FindPickRest
      # include Dry::Transaction
      include Dry::Monads::Result::Mixin
      def call(rest_id)
        rest_entity = Repository::For.klass(Entity::RestaurantDetail).find_by_rest_id(rest_id)
        # if database results not found
        raise StandardError if rest_entity.nil?

        # send message to queue for update (trigger by clicks upon limit)
        Messaging::Queue.new(App.config.CLICK_QUEUE_URL, App.config)
          .send(rest_id)

        


        ## check if call the gmap api yet
        if rest_entity.google_rating.nil?
          # future will choose token randomly
          # GMAP_TOKEN = App.config.GMAP_TOKENS.sample(1) (GMAP_TOKENS are array of tokens)
          rest_detail_entity = Restaurant::RestaurantDetailMapper.new(rest_entity, App.config.GMAP_TOKEN).gmap_place_details

          repo_entity = Repository::RestaurantDetails.update(rest_detail_entity, true)
        else
          Repository::RestaurantDetails.update_click(rest_id)
          repo_entity = rest_entity
        end

        Response::PickRestaurantResp.new(repo_entity)
          .then do |rest_details|
          Success(Response::ApiResult.new(status: :ok, message: rest_details))
        end

      rescue StandardError
        Failure(Response::ApiResult.new(status: :not_found, message: '無此資料 Resource not found'))
      end
    end
  end
end
