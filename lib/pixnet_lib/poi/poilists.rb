# frozen_string_literal: false

# Food & Restaurant reviews and articles integrated application
module JustRuIt
  # Provide accesss to poi list data
  class PoiLists
    def initialize(poi_list_data)
      @poi_lists = poi_list_data
    end

    def poi_lists
      @poi_lists['data']
    end
  end
end
