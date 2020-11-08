# frozen_string_literal: true

require 'sequel'

module Ewa
  module Database
    # Object Relational Mapper for Project Entities
    class RestaurantOrm < Sequel::Model(:restaurants)
      one_to_one :articles,
                 class: :'Ewa::Database::ArticlesOrm'

      one_to_one :reviews,
                 class: :'Ewa::Database::ReviewsOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
