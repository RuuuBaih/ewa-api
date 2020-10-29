# frozen_string_literal: true

require 'http'
require 'yaml'
require_relative 'gmap_place_details'
include JustRuIt

config = YAML.safe_load(File.read('../../../config/secrets.yml'))

# RoseMary's place id
data = GmapPlaceDetailsApi.new(config['GMAP_TOKEN'], "ChIJ6di4z26pQjQRDuQAecDvA_U").place_details
