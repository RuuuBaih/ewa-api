# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'openstruct_with_id'
require_relative 'restaurant_details_representer'

module Ewa
  module Representer
    # Represents searched restaurants ids
    class SearchedRestaurants < Roar::Decorator
      include Roar::JSON
      property :details, extend: Representer::RestaurantDetails, class: Representer::OpenStructWithId
    end
  end
end
