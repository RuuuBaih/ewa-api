# frozen_string_literal: false

# Food & Restaurant reviews and articles integrated application
module JustRuIt
  # Provide accesss to gmap place data
  class PlaceId
    def initialize(place_id)
      @place_id = place_id
    end

    def place_id_data
      @place_id_data['data']
    end
  end
end
