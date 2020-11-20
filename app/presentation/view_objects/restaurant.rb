# frozen_string_literal: true

module Views
    # View for a single project entity
    class Restaurant
      def initialize(restaurant)
        @restaurant = restaurant
      end
  
      def entity
        @restaurant
      end
    
      def name
        @restaurant.name
      end

      def address
        @restaurant.address
      end

      def open_hours
        @restaurant.open_hours
      end

      def telephone
        @restaurant.telephone
      end

      def town
        @restaurant.town
      end

      def tags
        @restaurant.tags
      end

      def google_rating
        @restaurant.google_rating
      end

      def article
        @restaurant.article.link
      end

      def review_author_name
        @restaurant.reviews.author_name
      end

      def review_profile_photo_url
        @restaurant.reviews.review_profile_photo_url
      end

      def review_relative_time_description
        @restaurant.reviews.relative_time_description
      end

      def review_text
        @restaurant.reviews.text
      end

      def 
    end
  end