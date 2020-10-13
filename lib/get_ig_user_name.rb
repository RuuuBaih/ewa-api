# frozen_string_literal: true

# Eat a username by the argument
username = ARGV[0]
if not username then raise "Name argument not found!" end

require 'http'
require 'yaml'
require 'json'

def ig_api_path(username)
    "https://www.instagram.com/#{username}/?__a=1"
end

def call_ig_url(url)
    HTTP.get(url)
end

ig_response = {}
ig_results = {}

url = ig_api_path(username)
ig_response[username] = call_ig_url(url)

# HTTP Response object after .parse turn into a hash
username_obj = ig_response[username].parse


ig_results['user_id'] = username_obj['graphql']['user']['id']
ig_results['user_name'] = username_obj['graphql']['user']['username']

# put the username & user id into the yaml file which named by the username
File.open("../spec/fixtures/#{username}_ig_info.yml", "w") do |f|     
      f.write(ig_results.to_yaml) 
end


