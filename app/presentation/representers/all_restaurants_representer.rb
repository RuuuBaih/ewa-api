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
    end
  end
end
