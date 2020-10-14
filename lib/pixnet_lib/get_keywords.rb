# frozen_string_literal: true

# Eat a keyword by the argument and spits out a list of keywords related (order by related points)
keyword = ARGV[0]
if not keyword then raise "Keyword argument not found!" end

require 'http'
require 'yaml'
require 'json'

def get_keywords_api_path(keyword)
    "https://emma.pixnet.cc/explorer/keywords?format=json&key=" + keyword
end

def call_keyword_url(url)
    HTTP.get(url)
end

keyword_response = {}
keyword_results = {}

url = get_keywords_api_path(keyword)
keyword_response[keyword] = call_keyword_url(url)

# HTTP Response object after .parse turn into a hash
keyword_hash = keyword_response[keyword].parse


keyword_results['keyword_lists'] = keyword_hash['data']

# put the username & user id into the yaml file which named by the username
File.open("../../spec/fixtures/pixnet_data/keyword_lists/#{keyword}_realated_keywords.yml", "w") do |f|     
      f.write(keyword_results.to_yaml) 
end


