# frozen_string_literal: false

require_relative '../spec/spec_helper'
restaurant = Ewa::Restaurant::RestaurantMapper
             .new(GMAP_TOKEN)
