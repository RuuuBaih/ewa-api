# frozen_string_literal: false

# Food & Restaurant reviews and articles integrated application
module JustRuIt
  # Provide accesss to keyword lists data
  class KeywordLists
    def initialize(keyword_list_data)
      @keyword_lists = keyword_list_data
    end

    def keyword_lists
      @keyword_lists['data']
    end
  end
end
