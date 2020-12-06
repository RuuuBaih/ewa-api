# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'openstruct_with_id'
require_relative 'restaurant_id_name_representer'

module Ewa
  module Representer
    # Represents searched restaurants ids
    class SearchedRestaurants < Roar::Decorator
      include Roar::JSON
      collection :ids, extend: Representer::RestaurantIdName, class: Representer::OpenStructWithId
    end
  end
end
