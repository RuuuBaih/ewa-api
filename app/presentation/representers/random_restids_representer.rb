# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'openstruct_with_id'

module Ewa
  module Representer
    # Represents random ids of restaurants
    class RandomRestIds < Roar::Decorator
      include Roar::JSON
      collection :ids, class: Representer::OpenStructWithId



    end
  end
end
