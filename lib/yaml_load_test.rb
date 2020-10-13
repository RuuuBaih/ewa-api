
require 'yaml'

rainyjonne = YAML.safe_load(File.read("../spec/fixtures/rainyjonne_ig_info.yml"))

puts rainyjonne
