# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'


include Ewa

describe 'ShowAllRests Service Integration Test' do
  VcrHelper.setup_vcr

  before do 
    VcrHelper.configure_vcr_for_restaurant
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Show all rests' do

    it 'HAPPY: should be able to see all restaurants without any params. (default on page 1 and 5 records)' do
      # GIVEN: a valid request for restaurant lists
      restaurants = Repository::For.klass(Entity::Restaurant).all
      puts restaurants.first.inspect

      # WHEN: the service is called with the request form object
      empty_params = {}
      restaurants_made = Service::ShowAllRests.new.call(empty_params)
      puts restaurants_made.inspect

      # THEN: the result should report success
      _(restaurants_made.success?).must_equal true

      # ..and provide restaurants entities with right details
      rebuilt = restaurants_made.value!.message
      puts rebuilt.inspect

      #_(rebuilt.rests_infos)
      #_(rebuilt.)
    end
  end
end


