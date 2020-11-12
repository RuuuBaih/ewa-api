# frozen_string_literal: false

require_relative '../gateways/pix_api'
require_relative '../entities/article'

module Ewa
  # Provides access to restuarant articles
  module Restaurant
    # Data Mapper: Mapping article data into
    class ArticleMapper
      def initialize(keyword, gateway_class = Pixnet::ArticleApi)
        @keyword = keyword
        @gateway_class = gateway_class
      end

      # get the newest article of restaurant
      def the_newest_article
        data = {}
        data['keyword'] = @keyword
        # per_page should be set to > 2 or there are no results
        data['link'] = @gateway_class.new(10, 1, @keyword).article_lists['articles'][0]['link']
        data
      end

      # build Article Entity
      class BuildArticleEntity
        def initialize(data)
          @data = data
        end

        def build_entity
          DataMapper.new(@data).build_entity
        end
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Ewa::Entity::Article.new(
            id: nil,
            restaurant_name: name,
            link: link
          )
        end

        private

        def name
          @data['keyword']
        end

        def link
          @data['link']
        end
      end
    end
  end
end
