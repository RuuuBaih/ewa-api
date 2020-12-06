# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Ewa
  module Representer
    # Represents random ids of restaurants
    class RandomRestIds < Roar::Decorator
      include Roar::JSON
      collection :ids, class: Response::OpenStructWithId



    end
  end
end
