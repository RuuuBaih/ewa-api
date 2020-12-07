# frozen_string_literal: true

require_relative '../helpers/spec_helper'
require_relative '../helpers/vcr_helper'
require_relative '../helpers/database_helper'
require 'rack/test'

def app
  Ewa::App
end

describe 'Test API routes' do
  include Rack::Test::Methods

  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_restaurant
    DatabaseHelper.wipe_database
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Root route' do
    it 'should successfully return root information' do
      get '/'
      _(last_response.status).must_equal 200

      body = JSON.parse(last_response.body)
      _(body['status']).must_equal 'ok'
      _(body['message']).must_include 'api/v1'
    end
  end

  describe 'display rests infos' do
    it 'should be able to return rest infos' do

      get "/api/v1/restaurants"
      _(last_response.status).must_equal 200
      puts last_response.inspect
      rest_infos = JSON.parse last_response.body
      puts rest_infos
      _(rest_infos.count).must_equal 27
    end
  end
end