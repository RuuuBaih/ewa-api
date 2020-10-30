# frozen_string_literal: true

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
      attribute :reviews,       Strict::Array.of(Hash.schema(author_name: Strict::String.optional,
                                                             profile_photo_url: Strict::String.optional,
                                                             relative_time_description: Strict::String.optional,
                                                             text: Strict::String.optional,
                                                             language: Strict::String.optional))
    end
  end
end
