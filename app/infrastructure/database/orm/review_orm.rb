# frozen_string_literal: true

require "sequel"

module Ewa
  module Database
    # Object Relational Mapper for Review
    class ReviewOrm < Sequel::Model(:reviews)
      one_to_one :restaurant,
                 class: :'Ewa::Database::RestaurantOrm'

      plugin :timestamps, update_on_create: true

      def self.find_or_create(review_info)
        first(review_link: review_info[:link]) || create(review_info)
      end
    end
  end
end
