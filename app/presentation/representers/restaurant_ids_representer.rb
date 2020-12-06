# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Ewa
  module Representer
    # Represents searched restaurants' ids
    class RestaurantIds < Roar::Decorator
      include Roar::JSON

      property :id

    end
  end
end
