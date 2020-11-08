# frozen_string_literal: true

require 'sequel'

module Ewa
  module Database
    # Object Relational Mapper for Review
    class ReviewOrm < Sequel::Model(:reviews)
      many_to_one :restaurant,
                 class: :'Ewa::Database::RestaurantOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
