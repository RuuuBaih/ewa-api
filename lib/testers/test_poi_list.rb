# frozen_string_literal: false

require 'http'
require 'yaml'
require 'json'

# per_page = ARGV[0]

require_relative '../gateways/pix_poi_api'
include JustRuIt

data = PixPoiApi.new(1, 50).poi_lists

puts data
