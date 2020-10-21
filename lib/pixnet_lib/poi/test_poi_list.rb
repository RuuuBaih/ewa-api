# frozen_string_literal: false

require 'http'
require 'yaml'
require 'json'

per_page = ARGV[0]
require_relative 'pix_poi_api'
include JustRuIt
data = PixPoiApi.new(per_page)

poi_hash = data.poi_lists

# put the username & user id into the poi yaml file
File.open('../../../spec/fixtures/pixnet_data/poi.yml', 'w') do |f|
  f.write(poi_hash.to_yaml)
end
