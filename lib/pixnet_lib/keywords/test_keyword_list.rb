# frozen_string_literal: false

keyword = ARGV[0]
require_relative 'pix_keyword_api'
include JustRuIt
data = PixKeywordApi.new(keyword)
puts data.keyword_lists
