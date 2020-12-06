# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'restaurant_details_representer'

module Ewa
  module Representer
    # Represents all Restaurants ids & names
    class AllRestaurants < Roar::Decorator
      include Roar::JSON

      # :rests_infos include a collection of [ restaurant id & restaurant name ]
      collection :rests_infos, extend: Representer::RestaurantDetails, class: Response::OpenStructWithIdName
    
      link :options do
        "#{Api.config.API_HOST}/allrestaurants/rest_infos?town=#{town}&min=#{min}&max=#{max}"
      end

      link :all_details do
        "#{Api.config.API_HOST}/allrestaurants/rest_infos/details"
      end

      link :option_details do
        "#{Api.config.API_HOST}/allrestaurants/rest_infos/details?option_list={#{options}}"
      end

      link :random do
        "#{Api.config.API_HOST}/allrestaurants/rest_infos/random"
      end

      link :random_details do
        "#{Api.config.API_HOST}/allrestaurants/rest_infos/details?random_list={#{random}}"
      end
  end
end
