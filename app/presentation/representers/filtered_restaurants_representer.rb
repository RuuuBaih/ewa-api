# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'restaurant_details_representer'

module Ewa
  module Representer
    # Represents filtered restaurant ids & names
    class FilteredRestaurants < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      # :filtered_rests_infos include a collection of [ restaurant id ]
      collection :filtered_rests_infos, extend: Representer::RestaurantDetails, class: Response::OpenStructWithId
      
      link :filtered_details do
        "#{Api.config.API_HOST}/filtered_restaurants/filtered_rests_infos/details"
      end

      link :filtered_random do
        "#{Api.config.API_HOST}/filtered_restaurants/filtered_rests_infos/random"
      end

      link :filtered_random_details do
        "#{Api.config.API_HOST}/filtered_restaurants/filtered_rests_infos/details?random_list={#{filtered_random}}"
      end
    
    end
  end
end
