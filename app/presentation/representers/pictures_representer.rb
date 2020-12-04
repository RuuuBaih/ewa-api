# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'picture_representer'

module Ewa
  module Representer
    # Represents pictures of one specific restaurant
    class Pictures < Roar::Decorator
      include Roar::JSON

      collection :pictures, extend: Representer::Picture, class: OpenStruct
    end
  end
end
