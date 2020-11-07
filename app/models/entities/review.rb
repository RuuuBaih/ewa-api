# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module Ewa
  module Entity
    # Article Entity
    class Review < Dry::Struct
      include Dry.Types
      attribute :review_id, Integer.optional
      attribute :author_name, String.optional
      attribute :profile_photo_url, Strict::String.optional
      attribute :relative_time_description, Strict::String.optional
      attribute :text, Strict::String.optional
    end
  end
end