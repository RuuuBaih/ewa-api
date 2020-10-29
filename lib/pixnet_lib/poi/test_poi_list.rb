# frozen_string_literal: false

require 'http'
require 'yaml'
require 'json'

# per_page = ARGV[0]

require_relative 'pix_poi_api'
include JustRuIt

data = PixPoiApi.new(1, 10,'', '台北市', '大安區', '300', '')

puts data

