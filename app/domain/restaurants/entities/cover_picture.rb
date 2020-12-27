# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module Ewa
  module Entity
    # Cover Picture Entity
    class CoverPicture < Dry::Struct
      include Dry.Types
      attribute :id, Integer.optional
      attribute :picture_link, Strict::String.optional
      attribute :article_link, Strict::String.optional

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
