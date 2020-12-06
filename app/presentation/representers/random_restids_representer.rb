# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Ewa
  module Representer
    # Represents random ids of restaurants
    class RandomRestIds < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer
      collection :ids, class: Response::OpenStructWithId

      link :random_details do
        "#{Api.config.API_HOST}/random_rest_ids/ids/details"
      end

    end
  end
end
