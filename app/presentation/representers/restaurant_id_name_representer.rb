# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Ewa
  module Representer
    # Represents searched restaurants' ids & names
    class RestaurantIdName < Roar::Decorator
      include Roar::JSON

      property :id
      property :name

    end
  end
end
