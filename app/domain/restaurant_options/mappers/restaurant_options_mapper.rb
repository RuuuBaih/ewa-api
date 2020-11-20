# frozen_string_literal: true

module Ewa
  module Mapper
    # Get filtered restaurant_repo_entites
    class RestaurantOptions
      def initialize(filtered_all)
        @filtered_all = filtered_all
      end

      # Get random repository entities of restaurants
      def random_9picks
        @filtered_all.sample(9)
      end

      # get restaurant id
      class GetRestId
        def initialize(nine_picks)
          @nine_picks = nine_picks
        end

        # Get an array of restaurant ids of 9 picked restaurants
        def _9_id_infos
          @nine_picks.map(&:id)
        end
      end
    end
  end
end
