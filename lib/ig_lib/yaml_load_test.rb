
require 'yaml'

rainyjonne = YAML.safe_load(File.read("../../spec/fixtures/ig_data/rainyjonne_ig_info.yml"))

puts rainyjonne
