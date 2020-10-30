# frozen_string_literal: true

module Ewa
  module Entity
    # Restaurant Entity
    class Reviews < Dry::Struct
      include Dry::Types.module

      attribute :reviews_id,                Integer.required
      attribute :author_name,               Strict::String.optional
      attribute :profile_photo_url,         Strict::String.optional
      attribute :relative_time_description, Strict::String.optional
      attribute :text,                      Strict::String.optional
      attribute :language,                  Strict::String.optional
    end
  end
end
