# frozen_string_literal: true

require_relative '../init'
include Ewa
include Request

params = 'name=私宅打邊爐'
params_2 = 'town=中山區&min_money=10&max_money=1000'

#names = Request::SelectbyName.new(params).call
names = Request::SelectbyTown.new(params_2).call
puts names.value!
