# frozen_string_literal: true

require_relative '../app/models/gateways/pix_api'
require 'yaml'

include Ewa
include Pixnet

config = YAML.safe_load(File.read('config/secrets.yml'))

poi_name = PoiApi.new(1, 1).poi_lists['data']['pois'][0]['name']
puts poi_name
poi_article = ArticleApi.new(1, 1, poi_name).article_lists['articles'][0]['link']
puts poi_article
# .inspect
