# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
<<<<<<< HEAD
require_relative 'openstruct_with_id'
=======
>>>>>>> origin
require_relative 'restaurant_details_representer'

module Ewa
  module Representer
    # Represents searched restaurants infos
    class SearchedRestaurants < Roar::Decorator
      include Roar::JSON
<<<<<<< HEAD
      property :details, extend: Representer::RestaurantDetails, class: Representer::OpenStructWithId
=======

      # returns searched rests details by restaurant name 
      collection :searched_rests, extend: Representer::RestaurantDetails
>>>>>>> origin
    end
  end
end
