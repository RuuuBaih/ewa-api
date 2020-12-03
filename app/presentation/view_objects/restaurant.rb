# frozen_string_literal: true

module Views
  # View for a single project entity
  class Restaurant
    def initialize(restaurant)
      @restaurant = restaurant
    end

    def entity
      @restaurant
    end

    def id
      @restaurant.id
    end

    def pic_link
      @restaurant.picture.link
    end
  end
end
