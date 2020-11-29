# frozen_string_literal: true

module Views
    # View for a single project entity
    class Resdetail
      def initialize(resdetail)
        @resdetail = resdetail
      end
  
      def entity
        @resdetail
      end
    
      def ewa_tag
        @resdetail.ewa_tag.ewa_tag
      end

      def name
        @resdetail.name
      end

      def telephone
        @resdetail.telephone
      end

      def address
        @resdetail.address
      end

      def money
        @resdetail.money
      end

      def google_rating
        @resdetail.google_rating
      end

      def pic_link
        @resdetail.pictures.link
      end

      def article_link
        @resdetail.article.link
      end

      def author_name
        @resdetail.reviews.author_name
      end

      def profile_photo_url
        @resdetail.reviews.review_profile_photo_url
      end

      def review_relative_time_description
        @resdetail.reviews.relative_time_description
      end

      def review_text
        @resdetail.reviews.text
      end
      
      def branch_store_name
        @resdetail.branch_store_name
      end
      
    end
  end