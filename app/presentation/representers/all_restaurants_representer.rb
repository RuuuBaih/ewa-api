# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'restaurant_id_name_representer'
require_relative 'openstruct_with_id_name'

module Ewa
  module Representer
    # Represents all Restaurants ids & names
    class AllRestaurants < Roar::Decorator
      include Roar::JSON
      

      # :rests_infos include a collection of [ restaurant id & restaurant name ]
      collection :rests_infos, extend: Representer::RestaurantIdName, class: Representer::OpenStructWithIdName
    

    end  
  end
end
