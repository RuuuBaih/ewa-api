require "roda"
require "yaml"

module Ewa
  #Configuration for the App
  class App < roda
    CONFIG = YAML.safe_load(File.read("config/secrets.yml"))
    GMAP_TOKEN = CONFIG["GMAP_TOKEN"]
  end
end
