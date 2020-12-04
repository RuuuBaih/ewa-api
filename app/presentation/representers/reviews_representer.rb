# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'review_representer'

module Ewa
  module Representer
    # Represents reviews of one specific restaurant
    class Reviews < Roar::Decorator
      include Roar::JSON

      collection :reviews, extend: Representer::Review, class: OpenStruct
    end
  end
end
