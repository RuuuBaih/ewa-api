# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'restaurant_id_name_representer'
require_relative 'openstruct_with_id'

module Ewa
  module Representer
    # Represents filtered restaurant ids & names
    class FilteredRestaurants < Roar::Decorator
      include Roar::JSON

      # :filtered_rests_infos include a collection of [ restaurant id & names]
      collection :filtered_rests_infos, extend: Representer::RestaurantIdName, class: Representer::OpenStructWithId
      

    
    end
  end
end
