# frozen_string_literal: true

require 'roda'
require 'slim'

module Ewa
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt

    route do |routing|
      routing.assets # load CSS

      # GET /
      routing.root do
        view 'home'
      end

      routing.on 'restaurant' do
        routing.is do
          # POST /restaurant
          routing.post do
            restaurant_object = Restaurant::RestaurantMapper
                .new(GMAP_TOKEN)
                .restaurant_obj_lists[0]

          view 'restaurant', locals: { restaurant: restaurant_object }
          end
        end
      end
    end
  end
end
