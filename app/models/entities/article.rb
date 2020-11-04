# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module Ewa
  module Entity
    # Article Entity
    class Article < Dry::Struct
      include Dry.Types
      attribute :article_id, Integer.optional
      attribute :restaurant_name, Strict::String
      attribute :link, Strict::String
    end
  end
end
