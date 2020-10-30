# frozen_string_literal: false

keyword = ARGV[0]
require_relative '../gateways/pix_keyword_api'
include JustRuIt
data = PixKeywordApi.new(keyword).keyword_lists
puts data
