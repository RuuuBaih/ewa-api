# frozen_string_literal: true

module Ewa
  module Response
    # all restaurants list
    RestaurantsResp = Struct.new(:total, :rests_infos)
  end
end
