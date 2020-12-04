# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'restaurant_details_representer'

module Ewa
  module Representer
    # Represents filtered restaurant ids & names
    class FilteredRestaurants < Roar::Decorator
      include Roar::JSON

      # :filtered_rests_infos include a collection of [ restaurant id ]
      collection :filtered_rests_infos, extend: Representer::RestaurantDetails, class: Response::OpenStructWithId
    end
  end
end
