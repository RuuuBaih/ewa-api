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
            restaurants = Repository::For.klass(Entity::Restaurant).all
            view 'restaurant', locals: { restaurants: restaurants }
          end
        end
      end
    end
  end
end
