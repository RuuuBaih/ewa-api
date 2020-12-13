# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'picture_representer'

module Ewa
  module Representer
    # Represents searched restaurants' ids & names
    class RestaurantIdNamePic < Roar::Decorator
      include Roar::JSON

      property :id
      property :name
      collection :pictures, extend: Representer::Picture, class: OpenStruct

      link :search by id do
        "#{Api.config.API_HOST}/api/v1/restaurants/picks/#{id}"

      link :search by name do
        "#{Api.config.API_HOST}/api/v1/restaurants/searches?name=#{name}"

    end
  end
end
