# frozen_string_literal: true

require_relative '../init'

require 'econfig'
require 'shoryuken'

# Shoryuken worker class to click restaurants in parallel
class ClickWorker
  extend Econfig::Shortcut
  Econfig.env = ENV['RACK_ENV'] || 'development'
  Econfig.root = File.expand_path('..', File.dirname(__FILE__))

  Shoryuken.sqs_client = Aws::SQS::Client.new(
    access_key_id: config.AWS_ACCESS_KEY_ID,
    secret_access_key: config.AWS_SECRET_ACCESS_KEY,
    region: config.AWS_REGION
  )

  include Shoryuken::Worker
  shoryuken_options queue: config.CLICK_QUEUE_URL, auto_delete: true


  def perform(_sqs_msg, request)
    rest_entity = Ewa::Representer::RestaurantDetails
      .new(OpenStruct.new).from_json(request)

    #GMAP_TOKEN = App.config.GMAP_TOKENS.sample(1)
    rest_detail_entity = Restaurant::RestaurantDetailMapper
        .new(rest_entity, App.config.GMAP_TOKEN).gmap_place_details

    Ewa::Repository::RestaurantDetails.update(rest_detail_entity, true)

  rescue StandardError => e
    print_error(e)
  end 

end