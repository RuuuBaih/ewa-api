# frozen_string_literal: true

module Ewa
    module Mapper
        # Get filtered restaurant_repo_entites
        class RestaurantOptions
            def initialize(filtered_all)
                @filtered_all = filtered_all
            end

            # Get random pics of restaurants
            def random_9picks
                @filtered_all.sample(9)
            end

            def pick_one(random_picks, choice_num)
                PickOne.new(random_picks, choice_num).restaurant_1pick
            end


            # Pick one restaurant to show details
            class PickOne
                def initialize(restaurant_9picks, choice_num)
                    @restaurant_9picks = restaurant_9picks
                    @choice_num = choice_num
                end

                def restaurant_1pick
                    # all options = all_restaurant_options called
                    RestaurantPick.new(
                        @restaurant_9picks,
                        @choice_num
                    ).restaurant_1pick
                end
            end
        end
    end
end
