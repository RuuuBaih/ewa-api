# frozen_string_literal: true

require_relative 'reviews.rb'

module Ewa
  module Entity
    # Restaurant Entity
    class Restaurant < Dry::Struct
      include Dry::Types.module

      attribute :restaurant_id, Integer.required
      attribute :name,          Strict::String.required
      attribute :town,          Strict::String.optional
      attribute :money,         Strict::Integer.optional
      attribute :city,          Strict::String.optional
      attribute :telephone,     Strict::String.optional
      attribute :cover_img,     Strict::String.optional
      attribute :tags,          Strict::Array.of(String).optional
      attribute :pixnet_rating, Strict::Integer.optional
      attribute :google_rating, Strict::Ingeter.optional
      attribute :open_hours,    Strict::Array.of(String).optional
      attribute :reviews,       Strict::Array.of(Reviews)
      attribute :reviews_id,    Integer.required
    end
  end
end
