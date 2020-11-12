# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
# require_relative 'helpers/database_helper'

describe 'Test Git Commands Mapper and Gateway' do
    VcrHelper.setup_vcr
    DatabaseHelper.setup_database_cleaner
  
    before do
      VcrHelper.configure_vcr_for_github
      DatabaseHelper.wipe_database
end  