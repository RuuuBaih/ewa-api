# frozen_string_literal: true

require 'http'
require 'yaml'
require_relative 'gmap_api'
include JustRuIt

config = YAML.safe_load(File.read('../../../config/secrets.yml'))

data = GmapApi.new(config['GMAP_TOKEN'], '高雄市政府').place_id
