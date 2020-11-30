# frozen_string_literal: true

require_relative '../app/domain/init'
require_relative '../app/infrastructure/gateways/init'
require 'yaml'
include Ewa
include Restaurant

config = YAML.safe_load(File.read('config/secrets.yml'))
token = config['development']['GMAP_TOKEN']

photos = [
  {
    "height": 6048,
    "html_attributions": [
      '<a href="https://maps.google.com/maps/contrib/102561816548690401636">Sky Lin</a>'
    ],
    "photo_reference": 'CmRaAAAAu9TVKuc-4KzwxeVD-dBM7bf_fIu2UALsYFWgu8LhbGZJvscH3eo8GviHmQM_dYP7JM4dclsQcpryT0R7ThAp7i-wQ6zw34YrFAOymZ9u690jHKkpGTGMpuPADmEej_OREhBpy3_E5smyNF0n8CbBoVqNGhQIENVfTzcNLEybJRcupbBBoF_mNw',
    "width": 8064
  },
  {
    "height": 3000,
    "html_attributions": [
      '<a href="https://maps.google.com/maps/contrib/104397931454618190085">陳語華</a>'
    ],
    "photo_reference": 'CmRaAAAAt4CZ0hsz5UhKwfYlzW-GV_-OqXcsYnXYWe85J6L2zUZ95iyuTrt_lsH9MQxI22EafeB0OSFV_6u8SC_2-4r5rR4X1_3aslAZH0E64vwv5gHAMzevqXvBWfvzjDnpLjbUEhCEduGUbExGItBP-xFeOrTHGhTwz9VB2cTx8iTQegnMn13ZbpXY5w',
    "width": 4000
  }
]
ret = PictureMapper.new(photos, token).photo_lists
puts ret
# puts ret
puts ret.inspect
