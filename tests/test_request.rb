# frozen_string_literal: true

require_relative '../init'
include Ewa
include Request

params = 'name=私宅打邊爐'

names = Request::SelectbyName.new(params)

puts names.inspect
