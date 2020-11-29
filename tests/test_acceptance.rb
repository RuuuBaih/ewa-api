# frozen_string_literal: true

#require_relative 'helpers/spec_helper'
#require_relative 'helpers/database_helper'
#require_relative 'helpers/vcr_helper'
require 'headless'
require 'watir'
require 'uri'

RESTAURANT = "restaurant"
PICK = "pick"

browser = Watir::Browser :firefox, headless: true


puts @browser
