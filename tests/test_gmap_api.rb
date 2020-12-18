# frozen_string_literal: true

require_relative '../app/infrastructure/gateways/gmap_api'
require 'yaml'

include Ewa
include Gmap

config = YAML.safe_load(File.read('config/secrets.yml'))

place_id = PlaceApi.new(config['GMAP_TOKEN'], 'RoseMary').place_id['candidates'][0]['place_id']
puts place_id
place_details = PlaceDetailsApi.new(config['GMAP_TOKEN'], place_id).place_details
puts place_details.inspect
# .inspect
