# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Ewa
  module Representer
    # Represents searched restaurants ids
    class SearchedRestaurants < Roar::Decorator
      include Roar::JSON
      collection :ids, extend: Representer::RestaurantDetails, class: Response::OpenStructWithId
    end
  end
end
