# frozen_string_literal: true

require_relative '../init'
# require_relative 'restaurant_details'
require 'econfig'
require 'shoryuken'

# Shoryuken worker class to create first click restaurants in parallel
module Ewa
  class ClickCreateWorker
    extend Econfig::Shortcut
    Econfig.env = ENV['RACK_ENV'] || 'development'
    Econfig.root = File.expand_path('..', File.dirname(__FILE__))

    Shoryuken.sqs_client = Aws::SQS::Client.new(
      access_key_id: config.AWS_ACCESS_KEY_ID,
      secret_access_key: config.AWS_SECRET_ACCESS_KEY,
      region: config.AWS_REGION
    )

    include Shoryuken::Worker
    shoryuken_options queue: config.CLICK_CREATE_QUEUE_URL, auto_delete: true

    def perform(_sqs_msg, request)
      rest_entity = Repository::For.klass(Entity::RestaurantDetail).find_by_rest_id(request)
      rest_detail_entity = Restaurant::RestaurantDetailMapper
                           .new(rest_entity, App.config.GMAP_TOKEN).gmap_place_details

      Repository::RestaurantDetails.update(rest_detail_entity, true)
    rescue StandardError => e
      puts e
    end
  end
end
