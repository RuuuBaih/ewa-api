# frozen_string_literal: true

require_relative '../helpers/spec_helper'
require_relative '../helpers/vcr_helper'
require_relative '../helpers/database_helper'
require 'rack/test'
require 'uri'

def app
  Ewa::App
end

describe 'Test API routes' do
  include Rack::Test::Methods

  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_restaurant
    #DatabaseHelper.wipe_database
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
      rest_infos = JSON.parse last_response.body
      _(rest_infos['rests_infos'].count).must_equal 5
    end

    it '(GOOD town) should report total for valid town' do
      url_good_town = URI::escape("/api/v1/restaurants?town=中山區")
      get "#{url_good_town}"
      _(last_response.status).must_equal 200
      rest_infos = JSON.parse last_response.body
      _(rest_infos['total'].class).must_equal Integer
    end

    it '(BAD town) should report not found for invalid town' do
      get "/api/v1/restaurants?town=123"
      _(last_response.status).must_equal 404
      body = JSON.parse(last_response.body)
      _(body['status']).must_equal 'not_found'
    end
  end

  describe 'search by id' do
    it 'should be able to return rest infos of id' do
      get "/api/v1/restaurants/picks/1"
      _(last_response.status).must_equal 200
      rest_infos_pick_1 = JSON.parse last_response.body
      _(rest_infos_pick_1['pick_rest']['id']).must_equal 1
      _(rest_infos_pick_1['pick_rest']['name']).must_equal "私宅打邊爐"
    end

    describe 'search by name' do
      it 'should be able to return rest infos of name' do
        url_search_name = URI::escape("/api/v1/restaurants/searches?name=私宅打邊爐")
        get "#{url_search_name}"
        _(last_response.status).must_equal 200
        rest_infos_name = JSON.parse last_response.body
        _(rest_infos_name['searched_rests'][0]['id']).must_equal 1
        _(rest_infos_name['searched_rests'][0]['name']).must_equal "私宅打邊爐"
      end
    end
  end
end