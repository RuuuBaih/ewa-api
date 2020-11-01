# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

Dir.glob("#{__dir__}/*.rb").each do |file|
  require file
end
